# terraform-ecs-fargate-cluster
Build an ECS Fargate cluster using Terraform. 


### VPC CIDR
```
> 10.0.0.0/24
   256
    FIRST IP	10.0.0.1		
	LAST IP		10.0.0.254
		
   AZ1 
		Public Subnet CIDR
		10.0.0.0/26
		64 - 5 (59)
		
		FIRST IP	10.0.0.1		
		LAST IP		10.0.0.62
		
		Private Subnet CIDR
		10.0.0.64/26
		64 - 5 (59)
		FIRST IP	10.0.0.65		
		LAST IP		10.0.0.126
		
   AZ2 
		Public Subnet CIDR
		10.0.0.128/26
		64 - 5 (59)
		
		FIRST IP	10.0.0.129		
		LAST IP		10.0.0.190
		
		Private Subnet CIDR
		10.0.0.192/26
		64 - 5 (59)
		FIRST IP	10.0.0.193		
		LAST IP		10.0.0.254

```		


### Terraform Commands :
```
	>  First command to run for a new configuration
	> terraform init
	
	> terraform fmt
	> terraform validate
	> terraform apply
	> terraform destroy

```
		
### Reference :

[AWS Fargate](https://aws.amazon.com/fargate/) |
[ECS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/getting-started-fargate.html) |
[ECS Service](https://www.terraform.io/docs/providers/aws/r/ecs_service.html) |
[Task Definition Parameter](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html) |
[Service Definition Parameter](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service_definition_parameters.html) |
[Task Networking](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-networking.html) |
[VPC Configuration](https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_AwsVpcConfiguration.html) |
[AWS Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) |
[Listener Configuration](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-listener.html) |
[Target Group](https://www.terraform.io/docs/providers/aws/r/lb_target_group.html) |
[Listener](https://www.terraform.io/docs/providers/aws/r/lb_listener.html) |
[Load balancer](https://www.terraform.io/docs/providers/aws/r/lb.html) |
		
## License
[MIT](https://choosealicense.com/licenses/mit/)		