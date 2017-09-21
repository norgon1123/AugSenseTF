python -m scripts.retrain \
  --bottleneck_dir=tf_files/bottlenecks \
  --how_many_training_steps=4000 \
  --model_dir=tf_files/models/ \
  --summaries_dir=tf_files/training_summaries/"mobilenet_0.75_192" \
  --output_graph=tf_files/retrained_graph.pb \
  --output_labels=tf_files/retrained_labels.txt \
  --architecture="mobilenet_0.75_192" \
  --image_dir=/mnt/c/Users/Neil/Desktop/"New folder"/clean_images

python -m tensorflow.python.tools.optimize_for_inference \
  --input=tf_files/retrained_graph.pb \
  --output=tf_files/optimized_graph.pb \
  --input_names="input" \
  --output_names="final_result"

python -m scripts.quantize_graph \
  --input=tf_files/optimized_graph.pb \
  --output=tf_files/rounded_graph.pb \
  --output_node_names=final_result \
  --mode=weights_rounded

gzip -c tf_files/rounded_graph.pb > tf_files/rounded_graph.pb.gz
gzip -l tf_files/rounded_graph.pb.gz
cp tf_files/rounded_graph.pb android/assets/graph.pb
cp tf_files/retrained_labels.txt android/assets/labels.txt
