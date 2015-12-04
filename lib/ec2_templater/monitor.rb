module Ec2Templater
  class Monitor
    def initialize(command, interval)
      @logger = Logger.new(STDOUT)
      @command = command
      @interval = interval
    end

    def run
      @logger.info 'Monitoring'
      setup_signal_handlers
      loop do
        command_result = @command.call
        if command_result.changed?
          @logger.info 'Notifying change'
          yield(command_result)
        end
        sleep @interval
      end
    end

    def setup_signal_handlers
      %w(INT TERM).each do |signal|
        trap signal do
          @logger.info "Recieved SIG#{signal}, shutting down."
          exit 0
        end
      end
    end
  end
end
