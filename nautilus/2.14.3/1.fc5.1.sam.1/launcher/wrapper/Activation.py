def activate(requirements):
    from bonobo.activation import activate
    try:
        return activate(requirements)
    except RuntimeError:
        return None
