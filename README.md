<h1>Deploy SockShop Microservice With EKS</h1>
<p>Amazon Elastic Kubernetes Service (EKS) provides an option of automating cluster management, allowing developers focus more on deploying and managing applications. It handles the availability and scaling of the resources in the cluster using predefined parameters. 
This project will show a systematic guide on deploying an ecommerce website using EKS. </p> <br>
The images for the application, listed below are hosted on dockerhub:
<table border="1">
  <thead>
    <tr>
      <th>Image</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>weaveworksdemos/frontend:0.3.12</td>
      <td>front-end</td>
    </tr>
    <tr>
      <td>weaveworksdemos/orders:0.4.7</td>
      <td>orders</td>
    </tr>
    <tr>
      <td>weaveworksdemos/catalogue:0.3.5</td>
      <td>catalogue</td>
    </tr>
    <tr>
      <td>weaveworksdemos/cataloguedb:0.3.0</td>
      <td>catalogue database</td>
    </tr>
    <tr>
      <td>weaveworksdemos/userdb:0.3.0 (mongo)</td>
      <td>userdb</td>
    </tr>
    <tr>
      <td>weaveworksdemos/user:0.4.7</td>
      <td>user</td>
    </tr>
    <tr>
      <td>weaveworksdemos/shipping:0.4.8</td>
      <td>shipping</td>
    </tr>
    <tr>
      <td>redis:alpine</td>
      <td>session</td>
    </tr>
    <tr>
      <td>rabbitmq:3.6.8-management</td>
      <td>rabbit mq</td>
    </tr>
    <tr>
      <td>weaveworksdemos/queuemaster:0.3.1</td>
      <td>queue master</td>
    </tr>
    <tr>
      <td>weaveworksdemos/payment:0.4.3</td>
      <td>payment</td>
    </tr>
    <tr>
      <td>weaveworksdemos/carts:0.4.8</td>
      <td>carts</td>
    </tr>
    <tr>
      <td>mongo</td>
      <td>carts and orders database</td>
    </tr>
  </tbody>
</table>
<p> To do this, I will create a pipeline with GitHub actions to:
<ul>
  <li>Create the EKS cluster with Terraform</li>
  <li>Deploy the application containers with TLS/SSL certificate from Let's Encrypt</li>
  <li>Configure monitoring for the application</li>
</ul>

Let’s go through the setup and leave the pipeline as the last step.
</p>
<h3>Terraform</h3>
<p> The terraform code to create the cluster is in the terraform directory.
I used the VPC and EKS modules for this. The cluster will be created in the VPC ID created from the VPC module.<br>
I have defined parameters for the cluster to create two node groups in two AZs and  use:
  <ul>
    <li> Instance types: t2.medium   </li>
    <li> Min-size: 1   </li>
    <li>  Scale to max-size: 2  </li>
  </ul>
  The state file will be stored in an S3 bucket
</p>
<hr>
<h3>Application Deployment</h3>
<p> To simplify the application deployment, I used helm. 
By running: </p>

```bash
helm create SockShopChart
```
<p>The SockShopChart directory is created with default files.
My custom kubernetes definition files are in the <i>SockShopChart/templates/</i> directory. 
While the charts will be defined as dependencies in the <i>SockShopChart/Charts.yaml</i> file.
</p>
<hr>
<h3>Monitoring</h3>
<p>For monitoring, the Prometheus and grafana charts will be used as defined in the <i>SockShopChart/Charts.yaml</i> file as dependencies</p>
<hr>
<h3>Pipeline</h3>
<p>The pipeline will be triggered on code push to the main branch and goes through these phases:</p>

<p align="center"><img src="https://github.com/user-attachments/assets/b0f3fa7c-ca96-4dd0-9b34-6258ea786e95" alt="Complete Job Build" width="100%" />
        Complete Job Build
</p>
</p>
<h4>Retrieves AWS credentials in repository secrets</h4>
<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/185afb7c-9e2a-430d-ab63-65a5198abb5b" alt="Workflow Code" width="100%"/></td>
    <td><img src="https://github.com/user-attachments/assets/80b48e2a-9e4e-4b1d-82ba-646f01d09612" alt="Workflow Output" width="100%"/></td>
    </tr>
  <tr>
    <td align="center">Step Code</td>
    <td align="center">Step Output</td>
 
  </tr>
</table>

<h4>Checks if the state file bucket already exists before attempting to create it</h4>
<table style="width: 100%;">
  <tr>
    <td align="center" style="width: 50%;">
       <img src="https://github.com/user-attachments/assets/f24f7a7f-1482-4aac-9a84-00474f7fc277" alt="Step Output" width="400" />
            <br />
      <b>Step Code</b>
    </td>
    <td align="center" style="width: 50%;">
      <img src="https://github.com/user-attachments/assets/c4109565-17f7-4ee0-9385-4613ce1c8a7a" alt="Step Code" width="400" />
      <br />
      <b>Step Output</b>
    </td>
  </tr>
</table>

<p align="center">
  <img src="https://github.com/user-attachments/assets/4268004d-fb34-4727-ae32-aa511264d31f" alt="Creates Bucket" width="400" />
  <br />
  <b>Creates Bucket</b>
</p>

<h4>Checks if cluster already exists</h4>
<table style="width: 100%;">
  <tr>
    <td align="center" style="width: 50%;">
      <img src="https://github.com/user-attachments/assets/2aadf596-7cc9-41c8-8a0a-83579c04469c" alt="Step Code" width="400" />
      <br />
      <b>Step Code</b>
    </td>
    <td align="center" style="width: 50%;">
      <img src="https://github.com/user-attachments/assets/7cefd82c-02dc-4b61-8f79-06e9da5b97c7" alt="Step Output" width="400" />
      <br />
      <b>Step Output</b>
    </td>
  </tr>
</table>

<p align="center">
  <img src="https://github.com/user-attachments/assets/f854cf98-6432-4060-a8a0-7c51febba126" alt="Creates Cluster" width="400" />
  <br />
  <b>Creates Cluster</b>
</p>













