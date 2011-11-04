require 'detroit/tool'

module Detroit

  #
  class LOCat < Tool

    #  A T T R I B U T E S

    # Limit paths of files to render.
    attr_accessor :path

    # Alias for `path`.
    alias_accessor :files, :path

    # Alias for `path`.
    alias_accessor :include, :path

    # Exclude subpaths from `path`.
    attr_accessor :exclude

    # Exclude subpaths from `path` by matching basename.
    attr_accessor :ignore

    # List of config files to use.
    attr_accessor :config

    # Output format cane be html, json or yaml. By default
    # the format will be determined by the `output` file extension.
    attr_accessor :format

    # Title to place at top of report.
    attr_accessor :title

    # File to generate.
    attr_accessor :output


    #  A S S E M B L Y  S T A T I O N S

    #
    def station_generate
      generate
    end

    #  S E R V I C E  M E T H O D S

    # Render templates.
    def generate
      options = {}
      options[:title]  = title  if title
      options[:format] = format if format
      options[:output] = output if output
      options[:config] = config if config

      options[:files]  = collect_files

      locat = ::LOCat::Command.new(options)

      locat.run
    end

  private

    #
    def collect_files
      amass(path, exclude, ignore)
    end

    #
    def initialize_requires
      require 'locat'
    end

    #
    def initialize_defaults
      @path = 'lib'
    end

  public

    def self.man_page
      File.dirname(__FILE__)+'/../man/detroit-locat.5'
    end

  end

end
