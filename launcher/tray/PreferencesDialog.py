def present():
    import bonobo.activation
    from BusyCursor import BusyCursor

    busy = BusyCursor()
    server = bonobo.activation.activate("iid == 'OAFIID:SamplerPreferences:0.1'")
