<h1>Deploy SockShop Microservice With EKS</h1>
<p>Amazon Elastic Kubernetes Service (EKS) provides an option of automating cluster management, allowing developers focus more on deploying and managing applications. It handles the availability and scaling of the resources in the cluster using predefined parameters. 
This project will show a systematic guide on deploying an ecommerce website using EKS. </p> <br>

<p>The deployment process will be as shown:</p>
<img src="https://github.com/user-attachments/assets/8c79d830-1d0a-40f5-8dbe-edf5f575a80a" alt="Resources Diagram Flow" width="600" />

<p>And resources will be created and accessed as shown:</p>
<img src="https://github.com/user-attachments/assets/bd572ab3-8734-4e60-b040-e2289c9e2abd" alt="Resources Plan" width="600" />





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

<h4>Checks if cluster already exists before creating</h4>
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


<h4>Update kubeconfig file and create sock-shop namespace</h4>
<table style="width: 100%;">
  <tr>
    <td align="center" style="width: 50%;">
       <img src="https://github.com/user-attachments/assets/87b24450-b8be-4a58-a065-7b01b92f90ed" alt="Step Output" width="400" />
       <br />
      <b>Step Code</b>
    </td>
    <td align="center" style="width: 50%;">
       <img src="https://github.com/user-attachments/assets/9b40c917-1c78-4f5c-940d-a20929bbe2e6" alt="Step Code" width="400" />
      <br />
      <b>Step Output</b>
    </td>
  </tr>
</table>

<h4>Create certificate manager for SSL/TLS</h4>
<table style="width: 100%;">
  <tr>
    <td align="center" style="width: 50%;">
       <img src="https://github.com/user-attachments/assets/db23bebd-3fae-467b-9433-6a8c799c0a78" alt="Create Certificate Manager" width="400" />
    </td>
    <td align="center" style="width: 50%;">
       <img src="https://github.com/user-attachments/assets/2b572798-1ba8-48af-9d55-5eb12cffc1a9" alt="Create Certificate Manager" width="400" />
    </td>
  </tr>
</table>

<h4>Install helm dependencies and custom files in the templates directory</h4>
<table style="width: 100%;">
  <tr>
    <td align="center" style="width: 50%;">
       <img src="https://github.com/user-attachments/assets/198f1b1e-ca9f-4fab-926e-1d6c3b07d520" alt="Install Helm Dependencies" width="400" />
    </td>
    <td align="center" style="width: 50%;">
       <img src="https://github.com/user-attachments/assets/8ddb4a7d-a67c-4829-b864-77b9050b7a06" alt="Install Helm Dependencies" width="400" />
    </td>
  </tr>
</table>
<br/>

<p>When the pipeline completes:</p>

<h4>The cluster is created</h4>
<img src="https://github.com/user-attachments/assets/b7ba96d8-ad75-49ca-9039-e39e7d0b2399" alt="Cluster Created" width="400" />

<h4>Load balancer is created by the ingress controller</h4>
<img src="https://github.com/user-attachments/assets/bb6a7850-7761-4be5-a426-6fb0ca89677b" alt="Load Balancer" width="400" />

<h4>A records for access with Route 53</h4>
<img src="https://github.com/user-attachments/assets/691267e3-539a-4549-8f05-edf890032a1a" alt="Route 53 Records" width="400" />

<h4>The pods are running</h4>
<img src="https://github.com/user-attachments/assets/c96b8f98-4d52-4200-9598-b405b87816c6" alt="Pods Running" width="400" />

<h4>The corresponding services are running</h4>
<img src="https://github.com/user-attachments/assets/309cb74f-843b-4676-809d-2e5bccfd621e" alt="Services Running" width="400" />

<h4>Front end is being served as well</h4>
<img src="https://github.com/user-attachments/assets/a92221d4-207d-443e-9c21-ef43d28d00ea" alt="Front End" width="1200" />


<h4>Logs from Prometheus</h4>
<table style="width: 100%;">
  <tr>
    <td align="center" style="width: 50%;">
       <img src="https://github.com/user-attachments/assets/c2a10eaf-79fa-41c7-8f28-024e5c11ab8e" alt="Prometheus Logs" width="400" />
    </td>
    <td align="center" style="width: 50%;">
       <img src="https://github.com/user-attachments/assets/ab23b1e6-6479-4e46-9f82-ccbbefe73ed8" alt="Memory Graph" width="400" />
    </td>
  </tr>
</table>

<h4>Monitoring on Grafana</h4>
<img src="https://github.com/user-attachments/assets/135f266c-2559-467e-97fa-d82460ae0755" alt="Grafana Monitoring" width="400" />

<h4>Monitoring on Lens</h4>
<table style="width: 100%;">
  <tr>
    <td align="center" style="width: 50%;">
       <img src="https://github.com/user-attachments/assets/48f1f6a1-e6af-47d7-a9be-a51bfc4f141b" alt="Lens Monitoring" width="400" />
    </td>
    <td align="center" style="width: 50%;">
       <img src="https://github.com/user-attachments/assets/efc40879-5b94-447f-becf-b0d58f89268f" alt="Lens Monitoring 2" width="400" />
    </td>
  </tr>
</table>

<h4>Logs can also be downloaded as a CSV file for further analysis</h4>
<img src="https://github.com/user-attachments/assets/46eeab3f-93db-455e-a7cd-572c07588c20" alt="Logs CSV" width="400" />
























































