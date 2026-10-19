extends Node

class AudioBus:
    const DefaultMusic: String = "Default_Music"
    const DefaultSFX: String = "Default_SFX"
    const SFX2D: String = "2DSFX"
    const Music2D: String = "2DMusic"

class PhysLayers:
    const Terrain: int = 1
    const Player: int = 2
    const Enemy: int = 4
    const XP: int = 8

class Controls:
    const Left := "Left"
    const Right := "Right"
    const Up := "Up"
    const Down := "Down"
    const Tab := "Focus"