extends Node

const backseater_name: String = "MetaMind"
const player_name: String = "YOU"

class MessageContent: # Pair holder for dialogue messages
    var sender: String
    var content: String
    func _init(username, message):
        sender = username
        content = message

const hint_pool: Array[String] = [
    "Try to avoid dying in the game, otherwise you anger the backseater",
    "The backseater will get more aggressive as the night goes on",
    "If you die too much in game, the backseater will attack you immediately",
    "The backseater makes a sound before attacking",
    "Try to focus more on the frail enemies early on in the game to level up quicker"
]

const night1_tutorial: Array[String] = [
    "Press 'Tab' to focus and unfocus on the monitor",
    "Press 'A' to look left",
    "Press 'D' to look right",
    "Survive until 12:00 AM",
    "The game is starting now, Good Luck"
]

const night2_tutorial: Array[String] = [
    "Press 'Space' to show your love for the meta when the time comes",
    "Good Luck"
]

const random_chat_messages: Array[String] = [
    "Oh Honey",
    "Oh that's not...",
    "Girl you can do better than that?",
    "That's not meta!",
    "This gameplay is not it",
    "I'm FIENDING right now",
    "Do you want me to send you the tier list?",
    "Oop",
    "This gameplay makes my tummy hurt",
    "Oh babes, it's so over",
    "That gameplay is UGLY",
    "THATS REALLY NOT META",
    "Girl what was that",
    "That's not optimal!",
    "Do you need my spreadsheet?",
    "This is what happens when you don't have spreadsheets",
    "Girl, do you need me to send the tutorial video?",
    "Oh that gameplay makes me gots to go",
    "Im screeching"
]

# Exchange before the start of the first night
var night1_exchange: Array[MessageContent] = [
    MessageContent.new(backseater_name, "Hello friend, its me!"),
    MessageContent.new(player_name, "what?"),
    MessageContent.new(backseater_name, "A little birdie told me you're looking for a new game :)"),
    MessageContent.new(player_name, "-_-"),
    MessageContent.new(backseater_name, "I'll send you the link when your off work!"),
    MessageContent.new(player_name, "fine")
]

# Exchange before start of night2 where anomalies start
var night2_exchange: Array[MessageContent] = [
    MessageContent.new(player_name, "did you pass by my house yesterday?"),
    MessageContent.new(backseater_name, "No, but I did find something cool yesterday!"),
    MessageContent.new(player_name, "weird"),
    MessageContent.new(backseater_name, "Did something happen?"),
    MessageContent.new(player_name, "i swear i heard sounds in my room last night"),
    MessageContent.new(backseater_name, "It's probably nothing"),
    MessageContent.new(backseater_name, "So game tonight? I'm THIRSTING right now"),
    MessageContent.new(player_name, "-_-"),
    MessageContent.new(backseater_name, "BTW, I saw your gameplay yesterday, that was not it girl"),
    MessageContent.new(backseater_name, "I'll be watching from now on and sending you constructive criticism!"),
    MessageContent.new(player_name, "wdym im not even streaming my game"),
    MessageContent.new(player_name, "????"),
    MessageContent.new(player_name, "-_-"),
]

var night3_exchange: Array[MessageContent] = [
    MessageContent.new(player_name, "OK IM CERTAIN, YOU TRIED TO BREAK INTO MY HOUSE YESTERDAY"),
    MessageContent.new(backseater_name, "Girl..."),
    MessageContent.new(backseater_name, "delulu"),
    MessageContent.new(player_name, "STOP LYING"),
    MessageContent.new(backseater_name, "Ok fine, I may have made a deal with something"),
    MessageContent.new(player_name, "WHAT?"),
    MessageContent.new(backseater_name, "It's for your own good!"),
    MessageContent.new(backseater_name, "Girl you were playing so inefficiently"),
    MessageContent.new(player_name, "SO YOU MADE A DEAL WITH A DEMON OR WHATEVER????"),
    MessageContent.new(backseater_name, "Actually it's not a demon, I think."),
    MessageContent.new(backseater_name, "So game tonight? I read a study today that playing with sounds is not an optimal way to play!"),
    MessageContent.new(backseater_name, "Sound actually distracts you from focusing on the game"),
    MessageContent.new(backseater_name, "Science!"),
    MessageContent.new(player_name, "WTF IM NOT PLAYING WITHOUT SOUND"),
    MessageContent.new(backseater_name, "Um, that may not be a good idea."),
    MessageContent.new(backseater_name, "Probably"),
    MessageContent.new(player_name, "-_-")
]

var night4_exchange: Array[MessageContent] = [
    MessageContent.new(player_name, "DUDE STOP SENDING YOUR DEMON TO BREAK INTO MY HOUSE"),
    MessageContent.new(player_name, "DO YOU KNOW EXPENSIVE IT IS TO CONSTANTLY FIX MY DOOR AND WINDOW?"),
    MessageContent.new(backseater_name, "Oh Honey..."),
    MessageContent.new(backseater_name, "It's too late to backout now!"),
    MessageContent.new(player_name, "BRO, I'M LITERALLY GOING TO DIE"),
    MessageContent.new(backseater_name, "All for the meta!"),
    MessageContent.new(player_name, "-_-"),
    MessageContent.new(backseater_name, "So game?"),
    MessageContent.new(player_name, "WHAT STUDY DID YOU READ THIS TIME?"),
    MessageContent.new(backseater_name, "Hear me out, zooming in your camera all the way is optimal!"),
    MessageContent.new(backseater_name, "More zoom means you need to move the mouse less! Ah I'm so smart"),
    MessageContent.new(player_name, "-_-"),
]

var ending_exchange: Array[MessageContent] = [
    MessageContent.new(backseater_name, "So game tonight? :)"),
    MessageContent.new(player_name, "-_-"),
    MessageContent.new(player_name, "i heard LardBunns started playing the game"),
    MessageContent.new(backseater_name, "AND HE DIDN'T TELL ME?"),
    MessageContent.new(backseater_name, "Oh honey, he's missing out"),
    MessageContent.new(player_name, "he actually just started today, he asked me how to play earlier"),
    MessageContent.new(backseater_name, "HE DIDN'T ASK ME?"),
    MessageContent.new(player_name, "honestly i think you should just help him out"),
    MessageContent.new(backseater_name, "Say less!"),
    MessageContent.new(backseater_name, "Thanks for playing!")
]