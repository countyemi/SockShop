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
