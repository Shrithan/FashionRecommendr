import torch
import torchvision.transforms as T
from torchvision import models
from PIL import Image
import numpy as np
import cv2
import mediapipe as mp
from flask import Flask, jsonify, request
from flask_cors import CORS
import Test
import os



app = Flask(__name__)
CORS(app)
app.config['UPLOAD_FOLDER'] = '/Users/pavanadipuram/Workspace/Shrithan/Boost-Hacks-2/app/uploads'
# UPLOAD_FOLDER = 'uploads'
# app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Initialize MediaPipe Pose
mp_pose = mp.solutions.pose
pose = mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5)
mp_drawing = mp.solutions.drawing_utils

# Function to process and display the skeleton
def detect_and_draw_skeleton(image, output_image, landmarks):
    landmarks = landmarks.landmark
    shoulder_left = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER]
    shoulder_right = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER]
    hip_left = landmarks[mp_pose.PoseLandmark.LEFT_HIP]
    hip_right = landmarks[mp_pose.PoseLandmark.RIGHT_HIP]
    
    h, w, _ = output_image.shape

    # Convert landmarks to pixel coordinates
    shoulder_left = (int(shoulder_left.x * w), int(shoulder_left.y * h))
    shoulder_right = (int(shoulder_right.x * w), int(shoulder_right.y * h))
    hip_left = (int(hip_left.x * w), int(hip_left.y * h))
    hip_right = (int(hip_right.x * w), int(hip_right.y * h))
    
    # Draw lines
    cv2.line(output_image, shoulder_left, shoulder_right, (0, 255, 0), 3)
    cv2.line(output_image, hip_left, hip_right, (0, 255, 0), 3)

    # Calculate line equations
    m = (shoulder_right[1] - shoulder_left[1]) / (shoulder_right[0] - shoulder_left[0])
    c = shoulder_right[1] - (m * shoulder_right[0])

    mh = (hip_right[1] - hip_left[1]) / (hip_right[0] - hip_left[0])
    ch = hip_right[1] - (mh * hip_right[0])

    return output_image, (0, c, w, ((w * m) + c)), (0, ch, w, ((w * mh) + ch))

# Function to decode the segmentation mask
def decode_segmap(image, nc=21):
    label_colors = np.array([(0, 0, 0),  # 0=background
                             (128, 0, 0), (0, 128, 0), (128, 128, 0), (0, 0, 128),
                             (128, 0, 128), (0, 128, 128), (128, 128, 128), (64, 0, 0),
                             (192, 0, 0), (64, 128, 0), (192, 128, 0), (64, 0, 128),
                             (192, 0, 128), (64, 128, 128), (192, 128, 128), (0, 64, 0),
                             (128, 64, 0), (0, 192, 0), (128, 192, 0), (0, 64, 128)])

    outline_image = np.zeros((image.shape[0], image.shape[1], 3), dtype=np.uint8)

    for l in range(1, nc):  # Skip background (label 0)
        idx = image == l
        outline_image[idx] = label_colors[l]

    outline_image_gray = cv2.cvtColor(outline_image, cv2.COLOR_BGR2GRAY)
    _, binary_mask = cv2.threshold(outline_image_gray, 1, 255, cv2.THRESH_BINARY)

    contours, _ = cv2.findContours(binary_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    outline = np.zeros_like(outline_image)
    cv2.drawContours(outline, contours, -1, (255, 0, 0), 3)  # Draw blue outline

    return outline, contours

# Function to find intersection of lines with contours
def find_line_intersections(line, contours):
    intersections = []
    
    x0, y0, x1, y1 = line

    for contour in contours:
        for i in range(len(contour)):
            pt1 = contour[i][0]
            pt2 = contour[(i + 1) % len(contour)][0]

            x2, y2 = pt1
            x3, y3 = pt2

            denom = (x0 - x1) * (y2 - y3) - (y0 - y1) * (x2 - x3)
            if denom == 0:
                continue

            intersect_x = ((x0 * y1 - y0 * x1) * (x2 - x3) - (x0 - x1) * (x2 * y3 - y2 * x3)) / denom
            intersect_y = ((x0 * y1 - y0 * x1) * (y2 - y3) - (y0 - y1) * (x2 * y3 - y2 * x3)) / denom

            if min(x0, x1) <= intersect_x <= max(x0, x1) and min(y0, y1) <= intersect_y <= max(y0, y1):
                if min(x2, x3) <= intersect_x <= max(x2, x3) and min(y2, y3) <= intersect_y <= max(y2, y3):
                    intersections.append((int(intersect_x), int(intersect_y)))

    return intersections

def calculate_distance(p1, p2):
    return ((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2) ** 0.5

def find_closest_pair(points):
    if len(points) % 2 == 0:    
        i = 0
        j = len(points) - 1
        min_distance = float('inf')
        while i < j:
            dist = calculate_distance(points[i], points[j])
            if dist < min_distance:
                min_distance = dist
            i += 1
            j -= 1
        return min_distance, True 
    else:
        return 0, False 

# Function to segment the image and draw points, lines, and skeleton
def segment_and_draw(image_path, height, x):
    print("Starting segmentation and drawing...")

    input_image = Image.open(image_path).convert('RGB')
    preprocess = T.Compose([
        T.ToTensor(),
        T.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ])
    input_tensor = preprocess(input_image)
    input_batch = input_tensor.unsqueeze(0)

    with torch.no_grad():
        output = model(input_batch)['out'][0]
    output_predictions = output.argmax(0)

    segmented_image, contours = decode_segmap(output_predictions.byte().cpu().numpy())

    if contours:
        largest_contour = max(contours, key=cv2.contourArea)

        topmost = tuple(largest_contour[largest_contour[:,:,1].argmin()][0])
        bottommost = tuple(largest_contour[largest_contour[:,:,1].argmax()][0])
        height_point_2 = topmost[0], bottommost[1]
        height_in_pixels = calculate_distance(height_point_2, topmost)

    try:
        segmented_image = cv2.cvtColor(segmented_image, cv2.COLOR_RGB2BGR)
    except cv2.error as e:
        print(f"Error converting segmented_image: {e}")
        return

    input_image = cv2.cvtColor(np.array(input_image), cv2.COLOR_RGB2BGR)
    image_rgb = cv2.cvtColor(input_image, cv2.COLOR_BGR2RGB)
    results = pose.process(image_rgb)

    if results.pose_landmarks:
        landmarks = results.pose_landmarks
        output_image, line_shoulder, line_hip = detect_and_draw_skeleton(input_image, segmented_image, landmarks)
        
        shoulder_intersections = find_line_intersections(line_shoulder, contours)
        hip_intersections = find_line_intersections(line_hip, contours)

        if x:
            min_distance, _ = find_closest_pair(hip_intersections)
        else:
            min_distance = calculate_distance(hip_intersections[0], hip_intersections[-1])
        
        shoulder_dist = calculate_distance(shoulder_intersections[0], shoulder_intersections[1])


        pixel_to_cm_ratio = height / height_in_pixels
        final_shoulder = pixel_to_cm_ratio * shoulder_dist
        final_hip = pixel_to_cm_ratio * min_distance
        
        print(f"Final shoulder distance: {final_shoulder} cm")
        print(f"Final hip distance: {final_hip} cm")
        
    else:
        print("No pose landmarks detected.")
    
    return segmented_image, final_shoulder, final_hip

x = True
# Initialize the model
model = models.segmentation.deeplabv3_resnet101(pretrained=False)
model.load_state_dict(torch.load("/Users/pavanadipuram/Workspace/Shrithan/Boost-Hacks-2/python/scripts/deeplabv3_resnet101_coco-586e9e4e.pth"), strict=False)
model.eval()


from datetime import datetime

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    if file:
        # Generate a unique filename using timestamp
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        file_extension = file.filename.split('.')[-1]  # Get file extension
        unique_filename = f"{timestamp}.{file_extension}"
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], unique_filename)
        file.save(file_path)
        print(f"File saved to: {file_path}")

        # Return the filename and a success message
        data = {
            'filename': unique_filename,
            'message': 'File uploaded successfully'
        }
        return jsonify(data)

    
@app.route('/process_images', methods=['POST'])
def process_images():
    # Extract parameters from the JSON request
    data = request.json
    height = data.get('height')
    # age = data.get('age')
    # gender = data.get('gender')
    
    # Initialize results dictionary
    results = {}
    
    # List files in the upload folder and ensure there are at least 2 images
    images = os.listdir(app.config['UPLOAD_FOLDER'])
    if len(images) < 2:
        return jsonify({"error": "Not enough images in the upload folder"}), 400
    
    # Process images
    file_path1 = os.path.join(app.config['UPLOAD_FOLDER'], images[len(images) - 2])
    file_path2 = os.path.join(app.config['UPLOAD_FOLDER'], images[len(images) - 1])
    o1, s1, h1 = segment_and_draw(file_path1, height=height, x = False)  # Process the first image
    o2, s2, h2 = segment_and_draw(file_path2, height=height, x = True)  # Process the second image
    
    # Call Test.final with additional parameters
    # Test.final(h2, h1, s2, height=height, age=age, gender=gender)
    
    # Add results to response (example placeholder)
    results = {
        's1': s1,
        's2': s2,
        'h1': h1,
        'h2': h2
    }
    # results['status'] = 'success'
    # results['message'] = 'Images processed successfully'
    
    return jsonify(results)

@app.route('/submit_data', methods=['POST'])
def submit_data():
    # Extract parameters from the JSON request
    data = request.json
    s1 = data.get('s1')
    s2 = data.get('s2')
    h1 = data.get('h1')
    h2 = data.get('h2')
    height = data.get('height')
    gender = data.get('gender')
    age = data.get('age')
    
    Test.final(shoulder=s1, hip1=h1, hip2=h2, height=height, age=age,gender=gender)
    # For now, we'll just print the received data to the console
    #print(f"Received data: s1={s1}, s2={s2}, h1={h1}, h2={h2}, height={height}, gender={gender}, age={age}")
    
    # Return a success message
    return jsonify({"status": "success", "message": "Data received successfully"}), 200


if __name__ == '__main__':
    app.run(debug=True, port=5001)