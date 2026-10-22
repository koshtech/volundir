#!/usr/bin/env ruby
# frozen_string_literal: true
require 'json'
require 'fileutils'

KOSHTECH_HOME   = ENV['KOSHTECH_HOME']
KOSHTECH_CONFIG = ENV['KOSHTECH_CONFIG']
INGOTS_ROOT     = ENV['INGOTS_ROOT']
VOLUNDIR_ENV    = ENV['VOLUNDIR_ENV']
VOLUNDIR_ROOT   = ENV['VOLUNDIR_ROOT']

require_relative "#{INGOTS_ROOT}/volundir-ruby/volundir/ruby/base/ingot_base"
require_relative "#{INGOTS_ROOT}/hamarr/volundir/ruby/cli/hamarr_maintenator"

begin
  # Load Bundler to ensure all dependencies/ingots are available.
  ENV['BUNDLE_GEMFILE'] ||= File.join(KOSHTECH_HOME, 'Gemfile')
  require 'bundler/setup'
  require 'debug' if ['development', 'test'].include?(VOLUNDIR_ENV)

  manifest_path = File.join(INGOTS_ROOT, 'volundir/config/setup/base_system.json')
  unless File.exist?(manifest_path)
    puts " [:Volundir][:Installer][:Error] Installation manifest not found."
    exit 1
  end

  manifest = JSON.parse(File.read(manifest_path))

  puts " [:Volundir][:Ruby][:Installer] Starting Pre-Install"
  (manifest['pre_install']['directories'] || []).each do |dir|
    FileUtils.mkdir_p(dir)
    puts "  [:Created] Directory: #{dir}"
  end

  puts " [:Volundir][:Ruby][:Installer] Downloading Core Components"
  (manifest['core_components'] || []).each do |comp|
    name   = comp['name']
    target = comp['target']

    if Dir.exist?(target)
      puts "  [:Ignored] #{name} already exists."
    else
      puts "  [:Clone] Downloading #{name}..."
      system("git clone #{comp['source']} #{target}")
    end

    ingot_manifest_path = File.join(INGOTS_ROOT, name, 'ingot.json')
    ingot_manifest = JSON.parse(File.read(ingot_manifest_path))

    if ingot_manifest["install"]
      install_section = ingot_manifest["install"]

      post_install = install_section["post_install"]

      (post_install['copy'] || []).each do |file|
        target = file['destination']

        if File.exist?(target)
          puts "  [:Ignored] #{target} already exists."
        else
          puts "  [:Copy] File #{target}..."
          FileUtils.cp("#{INGOTS_ROOT}/#{name}/#{file['source']}", "#{KOSHTECH_HOME}/#{target}")
        end
      end

      (post_install['symlinks'] || []).each do |symlink|
        target = symlink['destination']

        if File.exist?(target)
          puts "  [:Ignored] #{target} already exists."
        else
          puts "  [:Link] Symlink #{target}..."
          system("ln -s #{INGOTS_ROOT}/#{name}/#{symlink['source']} #{KOSHTECH_HOME}/#{target}")
        end
      end

    end

    system("ln -s #{INGOTS_ROOT}/#{name}/ingot.json #{VOLUNDIR_ROOT}/ingots/#{name}.json")
  end

  puts " [:Volundir][:Ruby][:Installer] Starting Post-Install"
  puts " [:Volundir][:Ruby][:Maintenator] Linking Core Components"
  (manifest['core_components'] || []).each do |comp|
    name   = comp['name']

    if Dir.exist?("#{INGOTS_ROOT}/#{name}/volundir")
      Volundir::Hamarr::Maintenator.sync_structure(["#{INGOTS_ROOT}/#{name}/volundir", VOLUNDIR_ROOT])
      puts "  [:Maintenator][:Ingot] #{name}/volundir: Done"
    else
      puts "  [:Maintenator][:Ingot] #{name}/volundir: Ignored"
    end

    if Dir.exist?("#{INGOTS_ROOT}/#{name}/bin")
      Volundir::Hamarr::Maintenator.sync_structure(["#{INGOTS_ROOT}/#{name}/bin", "#{KOSHTECH_HOME}/bin"])
      puts "  [:Maintenator][:Ingot] #{name}/bin: Done"
    else
      puts "  [:Maintenator][:Ingot] #{name}/bin: Ignored"
    end

    if Dir.exist?("#{INGOTS_ROOT}/#{name}/locales")
      Volundir::Hamarr::Maintenator.sync_structure(["#{INGOTS_ROOT}/#{name}/locales", "#{VOLUNDIR_ROOT}/locales"])
      puts "  [:Maintenator][:Ingot] #{name}/locales: Done"
    else
      puts "  [:Maintenator][:Ingot] #{name}/locales: Ignored"
    end

    if Dir.exist?("#{INGOTS_ROOT}/#{name}/config")
      FileUtils.cp_r("#{INGOTS_ROOT}/#{name}/config/.", "#{KOSHTECH_HOME}/config/")
      puts "  [:Maintenator][:Ingot] #{name}/config: Done"
    else
      puts "  [:Maintenator][:Ingot] #{name}/config: Ignored"
    end
  end

  post = manifest['post_install'] || {}

  # puts " [:Volundir][:Ruby][:Installer] Symlink Core Components"
  # (post['symlinks'] || []).each do |symlink|
  #   target = symlink['destination']
  #   if File.exist?(target)
  #     puts "  [:Ignored] #{target} already exists."
  #   else
  #     puts "  [:Link] Symlink #{target}..."
  #     system("ln -s #{INGOTS_ROOT}/#{symlink['source']} #{KOSHTECH_HOME}/#{target}")
  #   end
  # end

  (post['permissions'] || []).each do |file|
    File.chmod(0755, file) if File.exist?(file)
    puts "  [:Permissions] +x applyed on #{file}"
  end

  puts "[:Volundir] installation completed successfully!"

rescue LoadError => e
  warn "Error starting CLI: #{e.message}"
  warn "Execute 'bundle install' before running the command."

  exit 1
end
