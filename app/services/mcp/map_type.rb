require "json"
require "securerandom"

module Mcp
  class MapType
    include Mcp::Monads

    def self.call(payload:, policy:)
      new(payload, policy).call
    end

    def initialize(payload, policy)
      @payload = payload
      @policy  = policy
    end

    def call
      json_ld = normalize_payload(@payload)
      return json_ld if json_ld.is_a?(Failure)

      if json_ld["@id"]
        resolve_existing_type(json_ld)
      else
        infer_or_create_type(json_ld)
      end
    end

    private

    def normalize_payload(payload)
      parsed = if payload.respond_to?(:to_json_ld)
        JSON.parse(payload.to_json_ld)
      elsif payload.respond_to?(:to_json)
        JSON.parse(payload.to_json)
      else
        nil
      end

      return Failure(
        PolicyError.new(
          code: :invalid_payload,
          message: "Payload cannot be serialized to JSON or JSON-LD",
          policy: @policy
        )
      ) unless parsed.is_a?(Hash)

      Mcp::JsonLd.ensure_context(parsed)
    end

    def resolve_existing_type(json_ld)
      type = McpType.find_by(uri: json_ld["@id"])

      return Failure(
        PolicyError.new(
          code: :unknown_type,
          message: "Referenced McpType does not exist",
          policy: @policy,
          context: { uri: json_ld["@id"] }
        )
      ) unless type

      Success(attach_type(json_ld, type))
    end

    def infer_or_create_type(json_ld)
      unless @policy.allow_type_inference?
        return Failure(
          PolicyError.new(
            code: :untyped_input,
            message: "Untyped input not allowed by policy",
            policy: @policy
          )
        )
      end

      schema = infer_schema(json_ld)
      hash   = Mcp::StructuralHash.compute(schema)

      type = McpType.latest_by_hash(hash)

      if type
        Success(attach_type(json_ld, type))
      else
        create_type(schema, hash, json_ld)
      end
    end

    def create_type(schema, hash, json_ld)
      unless @policy.allow_type_creation?
        return Failure(
          PolicyError.new(
            code: :type_creation_forbidden,
            message: "Policy forbids type creation",
            policy: @policy
          )
        )
      end

      type = McpType.create!(
        uri: "/mcp/types/#{SecureRandom.uuid}",
        name: "AutoType",
        schema: schema,
        context: json_ld["@context"],
        structural_hash: hash,
        version: 1,
        environment: @policy.environment,
        created_by_policy_id: @policy.id
      )

      Success(attach_type(json_ld, type))
    end

    def infer_schema(json_ld)
      json_ld.reject { |k, _| k.start_with?("@") }
             .transform_values { |_v| "any" }
    end

    def attach_type(json_ld, type)
      json_ld.merge(
        "@id" => type.uri,
        "@context" => type.context
      )
    end
  end
end
