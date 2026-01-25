# frozen_string_literal: true

require_relative "../../lib/vendor_lock"

namespace :vendor do
  desc "Record current vendor submodule SHAs"
  task :lock do
    VendorLock.write_lock
    puts "Updated #{VendorLock::LOCK_PATH}"
  end

  desc "Verify vendor submodules match the recorded lock"
  task :verify do
    VendorLock.verify!
    puts "Vendor lock verified"
  end
end
