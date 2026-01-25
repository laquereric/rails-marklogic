module Mcp
  class StructuralHash
    def self.compute(schema)
      canonical = canonicalize(schema)
      Digest::SHA256.hexdigest(canonical)
    end

    def self.canonicalize(obj)
      case obj
      when Hash
        obj.keys.sort.map { |k| [ k, canonicalize(obj[k]) ] }.to_h.to_json
      when Array
        obj.map { |v| canonicalize(v) }.to_json
      else
        obj.class.name.to_json
      end
    end
  end
end
