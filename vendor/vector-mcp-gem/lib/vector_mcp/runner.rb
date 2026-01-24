module VectorMCP
  class Runner
    ROOT = File.expand_path("../../../references/vector-mcp", __dir__)

    def self.python
      venv = File.join(ROOT, ".venv", "bin", "python")
      return venv if File.exist?(venv)

      poetry = File.join(ROOT, "poetry.lock")
      return "poetry run python" if File.exist?(poetry)

      "python3"
    end

    def self.run(*args, json: false)
      py = python
      cmd = py.is_a?(String) && py.include?(" ") ? py.split(" ") : [py]
      cmd += ["-m", "vector_mcp", *args]

      Dir.chdir(ROOT) do
        if json
          output = IO.popen(cmd, &:read)
          require "json"
          JSON.parse(output)
        else
          system(*cmd)
        end
      end
    end
  end
end

    end
  end
end
