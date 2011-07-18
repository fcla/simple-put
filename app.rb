require 'digest/md5'
require 'digest/sha1'
require 'logger'

error do
  e = @env['sinatra.error']
  request.body.rewind if request.body.respond_to?('rewind')  

  text = []
  text.push "Internal Server Error - #{e.class} #{e.message}"

  Logger.err text[0], @env
  e.backtrace.each { |line| Logger.err(line, @env); text.push line }

  halt 500, { 'Content-Type' => 'text/plain' }, text.join("\n") + "\n"
end


configure do
  disable :logging        # Stop CommonLogger from logging to STDERR, please.
  disable :dump_errors    # Set to true in 'classic' style apps (of which this is one) regardless of :environment; it
                          # adds a backtrace to STDERR on all raised errors (even those we properly handle). Not so good.

  set :environment,  :production             # Get some exceptional defaults.
  set :raise_errors,  false                  # Handle our own errors


  Logger.setup('SimpleGet')
  Logger.stderr
end

put '/:name' do |name|
  start = Time.now
  data = request.body

  if not data.respond_to? "read"
    halt 500, "data not readable"
  end

  md5  = Digest::MD5.new
  sha1 = Digest::SHA1.new

  size = 0
  while buff = data.read(4 * 1024 * 1024)
    size += buff.length
    md5 << buff
    sha1 << buff
  end

  status 200
  headers 'Content-Type' => 'text/plain'
  "Name: #{name};  MD5: #{md5.hexdigest};  SHA1: #{sha1.hexdigest};  size: #{size}\n" +
  "Started: #{start}; finished: #{Time.now}\n"
end
