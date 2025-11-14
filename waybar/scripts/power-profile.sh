#!/usr/bin/env bash

get_profile() {
    profile=$(powerprofilesctl get)
    case $profile in
        "performance")
            icon="󰓅"
            ;;
        "balanced")
            icon="󰾅"
            ;;
        "power-saver")
            icon="󰾆"
            ;;
    esac
    echo "{\"text\":\"$icon\",\"tooltip\":\"Power Profile: $profile\",\"class\":\"$profile\"}"
}

cycle_profile() {
    current=$(powerprofilesctl get)
    case $current in
        "performance")
            powerprofilesctl set balanced
            ;;
        "balanced")
            powerprofilesctl set power-saver
            ;;
        "power-saver")
            powerprofilesctl set performance
            ;;
    esac
}

case $1 in
    "--cycle")
        cycle_profile
        ;;
    *)
        get_profile
        ;;
esac
