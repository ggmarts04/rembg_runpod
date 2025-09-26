import runpod
from rembg import remove
import requests
import base64

def handler(job):
    job_input = job.get('input', {})
    image_url = job_input.get('image_url')

    if not image_url:
        return {"error": "Please provide an image_url."}

    try:
        response = requests.get(image_url)
        response.raise_for_status()
        
        input_bytes = response.content
        output_bytes = remove(input_bytes)
        
        img_str = base64.b64encode(output_bytes).decode("utf-8")

        return {"image": img_str}

    except requests.exceptions.RequestException as e:
        return {"error": f"Failed to download image: {e}"}
    except Exception as e:
        return {"error": f"An error occurred: {e}"}

runpod.serverless.start({"handler": handler})
