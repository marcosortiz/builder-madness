require 'json'
require 'aws-sdk-s3'


module S3
    class Manager

        NULL_VALUE = -1

        def initialize(opts={})
            @client  = Aws::S3::Client.new
        end

        def put_object(bucket_name, key, payload)
            csv = parse_cw_metrics(payload)
            resp = @client.put_object({
                body: csv, 
                bucket: bucket_name, 
                key: "raw/#{key}", 
            })
        end

        private_methods
        
        def parse_cw_metrics(payload)
            hash = {}
            payload.each do |e|
                e.timestamps.each_with_index do |t, i|
                    hash[t] ||= {}
                    hash[t][e.id] = e.values[i]
                end
            end

            csv = "recorded_at,cpu,mem,ior,iow\n"
            hash.each do |k, v|
                recorded_at = k
                cpu = v['cpu'] || NULL_VALUE
                mem = v['mem'] || NULL_VALUE
                diskio_read = v['diskio_read'] || NULL_VALUE
                diskio_write = v['diskio_write'] || NULL_VALUE
                csv += "#{recorded_at},#{cpu},#{mem},#{diskio_read},#{diskio_write}\n"
            end
            csv
        end
    end
end