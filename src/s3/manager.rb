require 'json'
require 'aws-sdk-s3'


module S3
    class Manager


        def initialize(opts={})
            @client  = Aws::S3::Client.new
        end

        def put_object(bucket_name, instance_id, payload)
            csv = parse_cw_metrics(payload)
            resp = @client.put_object({
                body: csv, 
                bucket: bucket_name, 
                key: "raw/#{instance_id}_#{Time.now.to_i}.csv", 
            })
        end

        private_methods
        
        def parse_cw_metrics(payload)
            csv = "recorded_at,cpu,mem,ior,iow\n"
            payload[0].timestamps.size.times do |i|
                recorded_at = payload[0].timestamps[i]
                cpu = payload[0].values[i]
                csv += "#{recorded_at},#{cpu},0,0,0\n"
            end
            csv
        end
    end
end