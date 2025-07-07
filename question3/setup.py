from setuptools import setup, Extension

setup(
    name='iot_backend',
    version='1.0',
    ext_modules=[Extension('iot_backend', sources=['iot_backend.c'])],
)
