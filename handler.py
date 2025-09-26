import runpod
from rembg import remove
import requests
import base64

def handler(job):
    """
    Handler function for RunPod serverless background removal service.
    """
    job_input = job.get('input', {})
    image_url = job_input.get('image_url')
    
    if not image_url:
        return {"error": "Please provide an image_url."}
    
    try:
        # Download the image
        response = requests.get(image_url, timeout=30)
        response.raise_for_status()
        
        # Remove background
        input_bytes = response.content
        output_bytes = remove(input_bytes)
        
        # Convert to base64
        img_str = base64.b64encode(output_bytes).decode("utf-8")
        
        return {
            "status": "success",
            "image": img_str,
            "message": "Background removed successfully"
        }
        
    except requests.exceptions.RequestException as e:
        return {"error": f"Failed to download image: {str(e)}"}
    except Exception as e:
        return {"error": f"An error occurred during processing: {str(e)}"}

# Start the RunPod serverless worker
runpod.serverless.start({"handler": handler})
