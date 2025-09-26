import runpod
from rembg import remove
import requests
from PIL import Image
import io
import base64

def handler(job):
    job_input = job.get('input', {})
    image_url = job_input.get('image_url')

    if not image_url:
        return {"error": "image_url not provided"}

    try:
        response = requests.get(image_url)
        response.raise_for_status()
        img = Image.open(io.BytesIO(response.content))
    except requests.exceptions.RequestException as e:
        return {"error": f"Failed to download image: {e}"}
    except IOError:
        return {"error": "Invalid image format"}

    output_bytes = remove(img)

    buffered = io.BytesIO(output_bytes)
    img_str = base64.b64encode(buffered.getvalue()).decode("utf-8")

    return {"image": img_str}

runpod.serverless.start({"handler": handler})