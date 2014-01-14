require 'detroit-standard'

module Detroit

  ##
  # LOCat is tool for generating LOC statistics.
  #
  # This tool targets the following stations of the standard toolchain:
  #
  # * generate
  #
  class LOCat < Tool

    # Attach to the `generate` phase.
    #
    # @!parse 
    #   include Standard
    #
    assembly Standard

    # Location of manpage for this tool.
    MANPAGE = File.dirname(__FILE__) + '/../man/detroit-locat.5'

    #
    def prerequisite
      require 'locat'
      @path = 'lib'
    end

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

    # This tool ties into the `generate` station of the
    # standard assembly.
    #
    # @return [Boolean]
    def assemble?(station, options={})
      return true if station == :generate
      return false
    end

  private

    #
    def collect_files
      f = [path].flatten.compact
      x = [exclude].flatten.compact
      i = [ignore].flatten.compact
      amass(f, x, i)
    end

  end

end
