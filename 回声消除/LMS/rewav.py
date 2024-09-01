import librosa
import soundfile as sf

def resample_audio(input_file, output_file, target_sr):
    # 加载音频文件
    y, sr = librosa.load(input_file)

    # 打印当前的采样率
    print(f"Original sampling rate: {sr} Hz")

    # 重采样音频
    y_resampled = librosa.resample(y, orig_sr=sr, target_sr=target_sr)

    # 使用soundfile库保存重采样后的音频文件
    sf.write(output_file, y_resampled, target_sr)


    # 打印目标采样率
    print(f"Resampled to: {target_sr} Hz")

# 使用示例
input_file_path = 'D:/PDS_FPGA/Audio_python_test/回声消除/LMS/audio [music].wav'  # 输入音频文件路径
output_file_path = 'D:/PDS_FPGA/Audio_python_test/回声消除/LMS/2222.wav'  # 输出音频文件路径
target_sampling_rate = 48000  # 目标采样率

resample_audio(input_file_path, output_file_path, target_sampling_rate)