from ultralytics.models.yolo import YOLO

model = YOLO("best.onnx")

results = model.predict(
    source="0",
    conf=0.6,
)
