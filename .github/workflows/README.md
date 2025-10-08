## Deployment

Trigger Methods:
• **Manual trigger**: Use workflow_dispatch to manually start the deployment
• **Automatic trigger**: Push to the main branch

### Deployment Gate:
• When deploying to the main branch, there's a Production environment gate that requires manual approval before deployment proceeds

### Workflow Overview:
The deployment.yml implements a 3-stage process:

1. Tagging: Generates timestamp-based tags (format: DDMMYYYYHHMM)
2. Build: 
   • Builds Docker image from ./Dockerfile
   • Pushes to GitHub Container Registry (ghcr.io/gitongacollin/web-app)
   • Requires Production environment approval
3. Deploy:
   • Configures AWS credentials
   • Creates environment file with secrets
   • Copies files to server via SCP
   • Runs application using Docker Compose

### Key Features:
1. Uses GitHub Container Registry for image storage
2. Deploys to AWS infrastructure 
3. Includes monitoring stack (Prometheus, Alertmanager, HAProxy)
4. Slack notifications configured 
5. Requires manual approval for production deployments