require 'json'
require 'aws-sdk-ec2'


module EC2
    class Manager


        def initialize(opts={})
            @client  = Aws::EC2::Client.new
        end

        def describe_instances(instance_id)
            resp = @client.describe_instances({
                instance_ids: [instance_id], 
            })
            type = resp.reservations[0].instances[0][:instance_type]
            image_id = resp.reservations[0].instances[0][:image_id]
            hash = {type: type, image_id: image_id}
        end

    end
end