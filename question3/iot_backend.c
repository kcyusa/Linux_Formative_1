#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <stdlib.h>
#include <time.h>

static PyObject* get_sensor_data(PyObject* self, PyObject* args) {
    srand(time(NULL));

    int temperature = 20 + rand() % 21;  // 20-40
    int humidity = 30 + rand() % 41;     // 30-70
    int battery = 20 + rand() % 81;      // 20-100

    return Py_BuildValue("{s:i,s:i,s:i}",
                         "temperature", temperature,
                         "humidity", humidity,
                         "battery", battery);
}

static PyMethodDef IOTMethods[] = {
    {"get_sensor_data", get_sensor_data, METH_NOARGS, "Fetch sensor readings"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef iotmodule = {
    PyModuleDef_HEAD_INIT,
    "iot_backend",
    "Simulated IoT Sensor Backend",
    -1,
    IOTMethods
};

PyMODINIT_FUNC PyInit_iot_backend(void) {
    return PyModule_Create(&iotmodule);
}
