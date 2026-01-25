# frozen_string_literal: true

require "json"
require "time"

module VendorLock
  LOCK_PATH = File.join("config", "vendor-lock.json")

  module_function

  def write_lock
    data = {
      "generated_at" => Time.now.utc.iso8601,
      "entries" => current_entries
    }

    File.write(LOCK_PATH, JSON.pretty_generate(data) + "\n")
  end

  def verify!
    raise "Missing #{LOCK_PATH}. Run `rake vendor:lock`." unless File.exist?(LOCK_PATH)

    lock = JSON.parse(File.read(LOCK_PATH))
    locked_entries = (lock["entries"] || []).map { |entry| [ entry.fetch("path"), entry ] }.to_h
    live_entries = current_entries.map { |entry| [ entry.fetch("path"), entry ] }.to_h

    mismatches = []

    (locked_entries.keys - live_entries.keys).each do |path|
      mismatches << "Submodule missing from working tree: #{path}"
    end

    (live_entries.keys - locked_entries.keys).each do |path|
      mismatches << "Submodule not in lock file: #{path}"
    end

    (locked_entries.keys & live_entries.keys).each do |path|
      locked = locked_entries.fetch(path)
      live = live_entries.fetch(path)

      if locked.fetch("commit") != live.fetch("commit")
        mismatches << "#{path}: expected commit #{locked['commit']}, found #{live['commit']}"
      end

      if live.fetch("git_status") != " "
        mismatches << "#{path}: git status '#{live['git_status']}' indicates drift"
      end
    end

    raise mismatches.join("\n") unless mismatches.empty?
  end

  def current_entries
    output = `git submodule status`
    raise "Unable to read submodule status" unless $?.success?

    output.lines.map do |line|
      parse_line(line)
    end
  end

  def parse_line(line)
    match = line.match(/\A(?<status>.)(?<sha>[0-9a-f]{40})\s+(?<path>[^\s]+)(?:\s+\((?<info>.*)\))?\n?\z/)
    raise "Unrecognized submodule status line: #{line.inspect}" unless match

    {
      "path" => match[:path],
      "commit" => match[:sha],
      "git_status" => match[:status],
      "ref" => match[:info]
    }
  end
end
