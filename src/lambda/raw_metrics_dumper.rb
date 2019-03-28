require 'json'
require 'base64'
require 'zlib'
require 'stringio'

require_relative '../cw/manager'
require_relative '../s3/manager'

module Lambda
    class RawMetricsDumper

        @@cw_manager = CW::Manager.new
        @@s3_manager = S3::Manager.new
        
        def self.handler(event:, context:)

            data = event["awslogs"]["data"]
            decoded_payload = Zlib::GzipReader.new(StringIO.new(Base64.decode64(data))).read
            hash = JSON.parse(decoded_payload)
            s = hash['logEvents'].first['message']
            i = s.index('BenchmarkComplete')+'BenchmarkComplete'.size
            message_data =  s[i..-1]
            puts message_data
            arr = message_data.split(' ')
            instance_id = arr[0]
            start_time_str = arr[1]
            end_time_str = arr[2]

            
            now = Time.now.utc
            start_time = now-(60*60)
            end_time = now
            resp = @@cw_manager.get_metric_data(instance_id, start_time.utc , end_time.utc)
            

            bucket_name = 'buildermadness-houteamb-output'
            key = "#{instance_id}_#{start_time_str}_#{end_time_str}.csv"
            @@s3_manager.put_object(bucket_name, key, resp.metric_data_results)
        end
    
    end
end