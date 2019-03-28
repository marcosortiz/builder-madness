require 'json'
require 'aws-sdk-cloudwatch'
require_relative '../ec2/manager'

module CW
    class Manager

        CW_AGENT_NAMESPACE = 'CWAgent'
        MEM_METRIC_NAME = 'mem_used_percent'
        MEM_METRIC_UNIT = 'Percent'
        IOR_METRIC_NAME = 'diskio_reads'
        IOR_METRIC_UNIT = 'Count'
        IOW_METRIC_NAME = 'diskio_writes'
        IOW_METRIC_UNIT = 'Count'

        EC2_NAMESPACE = 'AWS/EC2'
        CPU_METRIC_NAME = "CPUUtilization"
        CPU_METRIC_UNIT = 'Percent'


        def initialize(opts={})
            @client  = Aws::CloudWatch::Client.new
            @ec2_client = EC2::Manager.new
        end

        
        def get_metric_data(instance_id, start_time, end_time)

            instance_details = @ec2_client.describe_instances(instance_id)
            instance_type = instance_details[:type]
            image_id = instance_details[:image_id]

            params = {
                metric_data_queries: [ # required
                  {
                    id: 'cpu', # required
                    metric_stat: {
                        metric: { # required
                            namespace: EC2_NAMESPACE,
                            metric_name: CPU_METRIC_NAME,
                            dimensions: [
                                {
                                    name: "InstanceId", # required
                                    value: instance_id, # required
                                },
                            ],
                        },
                        period: 1, # required
                        stat: "Maximum", # required
                        unit: CPU_METRIC_UNIT, 
                    },
                    return_data: true,
                },
                {
                    id: 'mem', # required
                    metric_stat: {
                        metric: { # required
                            namespace: CW_AGENT_NAMESPACE,
                            metric_name: MEM_METRIC_NAME,
                            dimensions: [
                                {
                                    name: "InstanceId", # required
                                    value: instance_id, # required
                                },
                                {
                                    name: "ImageId", # required
                                    value: image_id, # required
                                },
                                {
                                    name: "InstanceType", # required
                                    value: instance_type, # required
                                }
                            ],
                        },
                        period: 60, # required
                        stat: "Maximum", # required
                        unit: MEM_METRIC_UNIT, 
                    },
                    return_data: true,
                },
                {
                    id: 'diskio_read', # required
                    metric_stat: {
                        metric: { # required
                            namespace: CW_AGENT_NAMESPACE,
                            metric_name: IOR_METRIC_NAME,
                            dimensions: [
                                {
                                    name: "InstanceId", # required
                                    value: instance_id, # required
                                },
                                {
                                    name: "ImageId", # required
                                    value: image_id, # required
                                },
                                {
                                    name: "InstanceType", # required
                                    value: instance_type, # required
                                },
                                {
                                    name: "name", # required
                                    value: 'xvda', # required
                                },
                            ],
                        },
                        period: 60, # required
                        stat: "Maximum", # required
                        unit: IOR_METRIC_UNIT, 
                    },
                    return_data: true,
                },
                {
                    id: 'diskio_write', # required
                    metric_stat: {
                        metric: { # required
                            namespace: CW_AGENT_NAMESPACE,
                            metric_name: IOW_METRIC_NAME,
                            dimensions: [
                                {
                                    name: "InstanceId", # required
                                    value: instance_id, # required
                                },
                                {
                                    name: "ImageId", # required
                                    value: image_id, # required
                                },
                                {
                                    name: "InstanceType", # required
                                    value: instance_type, # required
                                },
                                {
                                    name: "name", # required
                                    value: 'xvda', # required
                                },
                            ],
                        },
                        period: 60, # required
                        stat: "Maximum", # required
                        unit: IOW_METRIC_UNIT, 
                    },
                    return_data: true,
                },
                ],
                start_time: start_time, # required
                end_time: end_time, # required
                scan_by: "TimestampAscending", # accepts TimestampDescending, TimestampAscending
                max_datapoints: 100800,
              }
              
              resp = @client.get_metric_data(params);
        end

    end
end