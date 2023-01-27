# Setup

1. Download and install [Python 3.x](https://www.python.org/downloads/windows/)
- If it is already installed, check in terminal:

```
python --version
```

2. Make sure to have the [latest pip version](https://pip.pypa.io/en/stable/installation/) installed

```
python.exe -m pip install --upgrade pip
```

3. Install robot framework

```
pip install robotframework
```

4. Install RESTinstance external library for RESTful JSON APIs

```
pip install --upgrade RESTinstance
```

# Run tests

```
robot -A robotargs.txt -i <tag from test(s)> tests
```

# Tools

- [Robot Framework](https://robotframework.org/robotframework/) documentation
> See latest [user guide](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)

> See [BuiltIn standard library](https://robotframework.org/robotframework/latest/libraries/BuiltIn.html)

- [RESTinstance](https://github.com/asyrjasalo/RESTinstance/) is a Robot Framework external library for RESTful JSON APIs. Find description about [keywords here](https://asyrjasalo.github.io/RESTinstance/).
