def present():
    from bonobo.activation import activate
    from BusyCursor import BusyCursor

    busy = BusyCursor()
    activate("iid == 'OAFIID:SamplerPreferences:0.1'")
    del busy
