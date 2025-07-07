import matplotlib.pyplot as plt # type: ignore
import matplotlib.animation as animation # type: ignore
import time
import iot_backend # type: ignore

data_time = []
data_temp = []
data_humidity = []
data_battery = []

start_time = time.time()

def update(frame):
    current_time = time.time() - start_time
    if current_time > 30:
        ani.event_source.stop()
        return

    sensor = iot_backend.get_sensor_data()
    print(f"[{int(current_time)}s] Temp: {sensor['temperature']}°C, Humidity: {sensor['humidity']}%, Battery: {sensor['battery']}%")

    data_time.append(current_time)
    data_temp.append(sensor['temperature'])
    data_humidity.append(sensor['humidity'])
    data_battery.append(sensor['battery'])

    ax1.clear()
    ax2.clear()
    ax3.clear()

    ax1.plot(data_time, data_temp, 'r-', label='Temperature (°C)')
    ax2.plot(data_time, data_humidity, 'b-', label='Humidity (%)')
    ax3.plot(data_time, data_battery, 'g-', label='Battery (%)')

    for ax in (ax1, ax2, ax3):
        ax.legend(loc='upper left')
        ax.set_xlim(0, 30)

fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(8, 8))
plt.tight_layout()
ani = animation.FuncAnimation(fig, update, interval=2000)

plt.show()
