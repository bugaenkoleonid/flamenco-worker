import bpy
import os

def enable_gpus(device_type):
    preferences = bpy.context.preferences
    preferences_cycles = preferences.addons["cycles"].preferences

    #query the devices

    preferences_cycles.get_devices()

    preferences_cycles_devices = preferences_cycles.devices

    compatible_devices = 0

    # Check for compatible device

    for device in preferences_cycles_devices:
        if device.type == device_type:
            compatible_devices += 1

    if compatible_devices == 0:
        raise RuntimeError("Unsupported device type")

    # Activate the device type

    preferences_cycles.compute_device_type = device_type

    for device in preferences_cycles_devices:
        if device.type == device_type:
            device.use = True
            print("activated " + device_type + " for " + device.name)

    bpy.ops.wm.save_userpref()

enable_gpus(os.getenv('DEVICE_TYPE'))