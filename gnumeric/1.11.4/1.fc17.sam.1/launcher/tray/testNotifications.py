#!/usr/bin/python

from gi.repository import Notify


def ignore(*args):
    pass

def main():
    Notify.init('Bug Isolation Monitor')
    note = Notify.Notification()
    note.add_action('toggle', 'Enable', ignore, None, None)


if __name__ == '__main__':
    main()
