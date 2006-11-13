import bonobo.activation

def activate(requirements):
    try:
        return bonobo.activation.activate(requirements)
    except RuntimeError:
        return None
