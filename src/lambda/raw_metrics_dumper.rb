require 'json'

require_relative '../cw/manager'
require_relative '../s3/manager'

module Lambda
    class RawMetricsDumper

        @@cw_manager = CW::Manager.new
        @@s3_manager = S3::Manager.new
        
        def self.handler(event:, context:)

            instance_id = 'i-039377027ea759f72'
            now = Time.now.utc
            start_time = now-(60*60)
            end_time = now
            resp = @@cw_manager.get_metric_data(instance_id, start_time.utc , end_time.utc)
            
            bucket_name = 'buildermadness-houteamb-output'
            @@s3_manager.put_object(bucket_name, instance_id, resp.metric_data_results)
        end
    
    end
end