# Setup for SMACK Server

### 1) Install SMACK
SMACK Server requires SMACK to be installed locally first. Read the tutorial at https://github.com/smackers/smack/blob/master/docs/installation.md to learn how to install SMACK for your system. 

## 2) Build The Rails Project

From the root of this project, run the command

`bundle install`

This will install the gems needed for the rails project to run

### 3) Run The Rails Project

To run SMACK Server, enter the command 
`rails s`


# About the SMACK SERVER

The server listens for incoming ‘POST /job/started’ requests. The request should contain a JSON object structured as:

{
“id”: string,
“options”: {  }
“input”: string* }
} 

*- The input should be a zip file encoded as Base64

When the server receives the request, it creates a new thread that runs the project using the JSON’s variables as arguments for the project’s parameters. The thread is also given information about the client. After initializing the project on a new thread, the server sends an “immediate” response back to the client, with a JSON structured as:

{
“id”: string,
“output”: ‘pending’
 }

Meanwhile, the server continues to run the SMACK process on a separate thread until the process is finished. Once completed, the server encodes the output as Base64 and returns it as a RESTful message to the client, “POST /projects”. The JSON is structured as:

{
“id”: string,
“output”: string
}

