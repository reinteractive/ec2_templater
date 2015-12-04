module Ec2Templater
  class Monitor
    def initialize(command, interval)
      @command = command
      @interval = interval
    end

    def run
      Ec2Templater.logger.info 'Monitoring'
      setup_signal_handlers
      loop do
        command_result = @command.call
        if command_result.changed?
          Ec2Templater.logger.info 'Notifying change'
          yield(command_result)
        end
        sleep @interval
      end
    end

    def setup_signal_handlers
      %w(INT TERM).each do |signal|
        trap signal do
          Ec2Templater.logger.info "Recieved SIG#{signal}, shutting down."
          exit 0
        end
      end
    end
  end
end
