# Ec2Templater

Ec2Templater provides a means of EC2 service discovery by templating your
server config.

It works by periodically querying AWS for the list of running EC2 instances,
rendering a template, then running a notify command if it has changed.
Using this setup you can provide, for example, a haproxy config that
updates based on instances that are available filtered by tag.

For a full example, see the 'example' directory.

Note: AWS_REGION must be set by ENV var.

## Groupings

You must provide a way of grouping EC2's by configuring groups.

These groups are configured with a 'name' you can reference in your template,
and a list of EC2 filters as described in the AWS documentation.

## Notification

Finally, a notify command will be called when the rendered template has
changed, enabling you to SIGHUP your server, or do a reload as required.

## Configuration

Provided config can include:

    template:   template ERB source
    target:     target file to write rendered template to
    interval:   time in seconds between renders
    notify_cmd: cmd to execute on change
    vars:       (optional) hash of vars to make available to the renderer
    groups:     hash of group names to ec2 filters, will be made available
                to the template as '@groups', with values changed to instances

The filters should match those defined for the describe-instances api call.
http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html

In your template, you can access groups as '@groups' which will
be a copy of the above hash with ec2 instances for each group name
in place of the filters.

The returned instances are <Types::Instance> from awssdk. See:
http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Types/Instance.html

Example:

    ---
    template: '/etc/haproxy_templater/haproxy.erb.cfg'
    target: '/etc/haproxy/haproxy.cfg'
    interval: 60
    notify_cmd: 'service haproxy reload'
    vars:
      other_vars: value
    groups:
      site_backends:
        tag:Environment: Production
        tag:Role: app
      kibana_backends:
       tag:Environment: Production
       tag:Role: log_index

Example @groups content:

    {
      site_backends: [ec2_instance, ...],
      kibana_backends: [ec2_instance, ..]
    }

Example invocation:

    $ AWS_REGION=ap-southeast-2 bundle exec ec2_templater --config example/config.yaml

## Installation

Install the gem into your server either as a specific user, or system wide.

```ruby
gem install 'ec2_templater'
```

## Usage

Run the daemon via the executable "ec2_templater" and provide the configuration
file with "-c":

```ec2_templater -c /etc/ec2_templater/config.yml```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Note that the specs are built to run an EC2 instance, then terminate it,
and the AWS API interactions have been recorded with VCR for fast playback.
To regenerate, start with an empty AWS account, set VCR to record :all rather
than :none, and rm -rf ./fixtures

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/reinteractive/ec2_templater. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
