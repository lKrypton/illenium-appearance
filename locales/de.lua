Locales["de"] = {
    UI = {
        modal = {
            save = {
                title = "Aussehen speichern",
                description = "Sie fahren mit diesem Look fort"
            },
            exit = {
                title = "Anpassung beenden",
                description = "Ihre Änderungen werden nicht gespeichert"
            },
            accept = "Ja",
            decline = "Nein"
        },
        ped = {
            title = "Charakter",
            model = "Modell"
        },
        headBlend = {
            title = "Erbe",
            shape = {
                title = "Gesicht",
                firstOption = "Vater",
                secondOption = "Mutter",
                mix = "Mix"
            },
            skin = {
                title = "Haut",
                firstOption = "Vater",
                secondOption = "Mutter",
                mix = "Mix"
            },
            race = {
                title = "Herkunft",
                shape = "Gesicht",
                skin = "Haut",
                mix = "Mix"
            }
        },
        faceFeatures = {
            title = "Gesichtszüge",
            nose = {
                title = "Nase",
                width = "Breite",
                height = "Höhe",
                size = "Größe",
                boneHeight = "Knochen Höhe",
                boneTwist = "Knochen Drehung",
                peakHeight = "Spitzenhöhe"
            },
            eyebrows = {
                title = "Augenbrauen",
                height = "Höhe",
                depth = "Tiefe"
            },
            cheeks = {
                title = "Wangen",
                boneHeight = "Knochen Höhe",
                boneWidth = "Knochen Breite",
                width = "Breite"
            },
            eyesAndMouth = {
                title = "Augen und Mund",
                eyesOpening = "Augenöffnung",
                lipsThickness = "Lippendicke"
            },
            jaw = {
                title = "Kiefer",
                width = "Breite",
                size = "Größe"
            },
            chin = {
                title = "Kinn",
                lowering = "Absenkung",
                length = "Länge",
                size = "Größe",
                hole = "Kerbengröße"
            },
            neck = {
                title = "Hals",
                thickness = "Dicke"
            }
        },
        headOverlays = {
            title = "Aussehen",
            hair = {
                title = "Haare",
                style = "Stil",
                color = "Farbe",
                highlight = "Glanzlichter",
                texture = "Textur",
                fade = "Ausblenden"
            },
            opacity = "Deckkraft",
            style = "Stil",
            color = "Farbe",
            secondColor = "Zweite Farbe",
            blemishes = "Hautunreinheiten",
            beard = "Bart",
            eyebrows = "Augenbrauen",
            ageing = "Altern",
            makeUp = "Makeup",
            blush = "Rouge",
            complexion = "Teint",
            sunDamage = "Sonnenschäden",
            lipstick = "Lippenstift",
            moleAndFreckles = "Muttermale und Sommersprossen",
            chestHair = "Brustbehaarung",
            bodyBlemishes = "Körperunreinheiten",
            eyeColor = "Augenfarbe"
        },
        components = {
            title = "Kleidung",
            drawable = "Modell",
            texture = "Textur",
            mask = "Maske",
            upperBody = "Arme",
            lowerBody = "Beine",
            bags = "Tasche und Fallschirm",
            shoes = "Schuhe",
            scarfAndChains = "Schal und Ketten",
            shirt = "Hemd",
            bodyArmor = "Körperpanzerung",
            decals = "Abzeichen",
            jackets = "Jacken",
            head = "Kopf"
        },
        props = {
            title = "Accessoires",
            drawable = "Modell",
            texture = "Textur",
            hats = "Hüte und Helme",
            glasses = "Brillen",
            ear = "Ohr",
            watches = "Uhren",
            bracelets = "Armbänder"
        },
        tattoos = {
            title = "Tattoos",
            items = {
                ZONE_TORSO = "Oberkörper",
                ZONE_HEAD = "Kopf",
                ZONE_LEFT_ARM = "Linker Arm",
                ZONE_RIGHT_ARM = "Rechter Arm",
                ZONE_LEFT_LEG = "Linkes Bein",
                ZONE_RIGHT_LEG = "Rechtes Bein"
            },
            apply = "Anwenden",
            applied = "Angewendet",
            buy = "Kaufen",
            delete = "Löschen",
            deleteAll = "Alle Tattoos löschen",
            opacity = "Deckkraft"
        }
    },

    outfitManagement = {
        title = "Outfit-Verwaltung",
        jobText = "Job-Outfits verwalten",
        gangText = "Gang-Outfits verwalten"
    },

    cancelled = {
        title = "Anpassung abgebrochen",
        description = "Anpassung wurde nicht gespeichert"
    },

    outfits = {
        import = {
            title = "Outfit-Code eingeben",
            menuTitle = "Outfit importieren",
            description = "Importieren Sie ein Outfit mit einem Freigabecode",
            name = {
                label = "Outfit-Name",
                placeholder = "Eine schöne Kombination",
                default = "Importiertes Outfit"
            },
            code = {
                label = "Outfit-Code"
            },
            success = {
                title = "Outfit importiert",
                description = "Sie können es über das Outfit-Menü wechseln"
            },
            failure = {
                title = "Import fehlgeschlagen",
                description = "Ungültiger Outfit-Code"
            }
        },
        generate = {
            title = "Outfit-Code generieren",
            description = "Erstellen Sie einen Outfit-Code zum Teilen",
            failure = {
                title = "Ein Fehler ist aufgetreten",
                description = "Outfit-Code konnte nicht generiert werden"
            },
            success = {
                title = "Outfit-Code generiert",
                description = "Ihr Outfit-Code ist bereit"
            }
        },
        save = {
            menuTitle = "Aktuelles Outfit speichern",
            menuDescription = "Speichern Sie Ihr aktuelles Outfit als %s",
            description = "Speichern Sie Ihr aktuelles Outfit",
            title = "Outfit-Name",
            managementTitle = "Outfit-Verwaltungsdetails",
            name = {
                label = "Outfit-Name",
                placeholder = "Sehr cooles Outfit"
            },
            gender = {
                label = "Geschlecht",
                male = "Männlich",
                female = "Weiblich"
            },
            rank = {
                label = "Mindestrang"
            },
            failure = {
                title = "Speichern fehlgeschlagen",
                description = "Ein Outfit mit diesem Namen existiert bereits"
            },
            success = {
                title = "Erfolg",
                description = "%s Outfit gespeichert"
            }
        },
        update = {
            title = "Outfit aktualisieren",
            description = "Aktuelles Outfit über ein vorhandenes speichern",
            failure = {
                title = "Aktualisierung fehlgeschlagen",
                description = "Dieses Outfit existiert nicht"
            },
            success = {
                title = "Erfolg",
                description = "%s Outfit aktualisiert"
            }
        },
        change = {
            title = "Outfit wechseln",
            description = "Wählen Sie eines Ihrer gespeicherten %s Outfits",
            pDescription = "Wählen Sie eines Ihrer gespeicherten Outfits",
            failure = {
                title = "Ein Fehler ist aufgetreten",
                description = "Das ausgewählte Outfit hat kein Basisaussehen"
            }
        },
        delete = {
            title = "Outfit löschen",
            description = "Ein gespeichertes %s Outfit löschen",
            mDescription = "Eines Ihrer gespeicherten Outfits löschen",
            item = {
                title = 'Löschen: "%s"',
                description = "Modell: %s%s"
            },
            success = {
                title = "Erfolg",
                description = "Outfit gelöscht"
            }
        },
        manage = {
            title = "👔 | %s Outfits verwalten"
        }
    },

    jobOutfits = {
        title = "Job-Outfits",
        description = "Wählen Sie eines Ihrer Job-Outfits"
    },

    menu = {
        returnTitle = "Zurück",
        title = "Kleiderschrank",
        outfitsTitle = "Spieler-Outfits",
        clothingShopTitle = "Bekleidungsgeschäft",
        barberShopTitle = "Friseur",
        tattooShopTitle = "Tattoo-Studio",
        surgeonShopTitle = "Plastischer Chirurg",
        savedOutfits = "Gespeicherte Outfits",
        switchUISide = "UI-Seite wechseln",
        rotateLeft = "Links drehen",
        rotateRight = "Rechts drehen",
        turnAround = "Umdrehen",
        wardrobeSubtitle = "Ihre gespeicherten Kombinationen",
        wardrobeEmpty = "Keine gespeicherten Outfits",
        wardrobeEmptyHint = "Speichern Sie Ihr aktuelles Outfit unten",
        lightSettings = "Studio-Beleuchtung",
        lightSubtitle = "Professionelles Licht-Setup",
        lightPresets = "Schnell-Voreinstellungen",
        lightIntensity = "Intensität",
        lightRotation = "Rotation",
        lightHeight = "Höhe",
        lightDistance = "Entfernung",
        restoreDefaults = "Standard zurücksetzen",
        toggleLight = "Studio-Licht",
        toggleHandsUp = "Hände hoch",
        favorites = "Favoriten",
        showAll = "Alle anzeigen",
        showFavorites = "Favoriten anzeigen",
        cancelPreload = "Abbrechen",
        startPreload = "Vorladen",
        loading = "Laden",
        synchronizing = "Assets werden synchronisiert...",
        preloadPause = "Pausieren",
        preloadRestart = "Neustart"
    },

    camera = {
        head   = "Kopf",
        body   = "Körper",
        bottom = "Beine",
        default = "Standardansicht"
    },

    clothing = {
        title = "Kleidung kaufen - $%d",
        titleNoPrice = "Kleidung wechseln",
        options = {
            title = "👔 | Bekleidungsgeschäft Optionen",
            description = "Wählen Sie aus einer Vielzahl von Kleidungsstücken"
        },
        outfits = {
            title = "👔 | Outfit-Optionen",
            civilian = {
                title = "Zivilisten-Outfit",
                description = "Tragen Sie Ihr eigenes Outfit"
            }
        }
    },

    commands = {
        reloadskin = {
            title = "Lädt Ihren Charakter neu",
            failure = {
                title = "Fehler",
                description = "Sie können reloadskin gerade nicht verwenden"
            }
        },
        fixped = {
            title = "Aktualisiert Ihren Charakter",
            failure = {
                title = "Fehler",
                description = "Sie können fixped gerade nicht verwenden"
            }
        },
        clearstuckprops = {
            title = "Entfernt alle feststeckenden Accessoires",
            failure = {
                title = "Fehler",
                description = "Sie können clearstuckprops gerade nicht verwenden"
            }
        },
        pedmenu = {
            title = "Outfit-Menü öffnen / vergeben",
            failure = {
                title = "Fehler",
                description = "Spieler ist nicht online"
            }
        },
        joboutfits = {
            title = "Öffnet das Job-Outfit-Menü"
        },
        gangoutfits = {
            title = "Öffnet das Gang-Outfit-Menü"
        },
        bossmanagedoutfits = {
            title = "Öffnet das vom Chef verwaltete Outfit-Menü"
        }
    },

    textUI = {
        clothing = "Bekleidungsgeschäft - Kosten: $%d",
        barber = "Friseur - Kosten: $%d",
        tattoo = "Tattoo-Studio - Kosten: $%d",
        surgeon = "Plastischer Chirurg - Kosten: $%d",
        clothingRoom = "Ankleideraum",
        playerOutfitRoom = "Outfits"
    },

    migrate = {
        success = {
            title = "Erfolg",
            description = "Migration abgeschlossen. %s Skins migriert",
            descriptionSingle = "Skin migriert"
        },
        skip = {
            title = "Info",
            description = "Skin übersprungen"
        },
        typeError = {
            title = "Fehler",
            description = "Ungültiger Typ"
        }
    },

    purchase = {
        tattoo = {
            success = {
                title = "Erfolg",
                description = "%s Tattoo für $%s gekauft"
            },
            failure = {
                title = "Tattoo konnte nicht angewendet werden",
                description = "Nicht genug Geld!"
            }
        },
        store = {
            success = {
                title = "Erfolg",
                description = "$%s wurde %s berechnet"
            },
            failure = {
                title = "Zahlung fehlgeschlagen",
                description = "Nicht genug Geld!"
            }
        },
        entrance = {
            failure = {
                title = "Geschäft kann nicht betreten werden",
                description = "Nicht genug Geld! Sie benötigen mindestens $%s auf Ihrem Konto."
            }
        }
    },

    peds = {
        commands = {
            pedmenu = "Öffnet Ihr Ped-Menü",
            pedadmin = "Ped für Spieler vergeben/entfernen (Admin)"
        },
        menu = {
            title = "🐾 | Ped-Verwaltung",
            myPeds = {
                title = "Meine Peds",
                description = "Anzeigen und Verwenden Ihrer Peds",
                empty = "Sie besitzen noch keine Peds"
            },
            setDefault = {
                title = "Standard-Ped festlegen",
                description = "Wählen Sie einen Ped zum automatischen Laden"
            },
            clearDefault = {
                title = "Standard löschen",
                description = "Standard-Ped-Einstellung entfernen"
            },
            reset = {
                title = "Zum normalen Aussehen zurückkehren",
                description = "Kehren Sie zu Ihrem ursprünglichen Charakter zurück"
            },
            currentDefault = "⭐ Aktueller Standard"
        },
        admin = {
            title = "🛡️ | Ped-Verwaltung — %s",
            customCategory = "Benutzerdefinierte Peds",
            invalidPlayer = "Ungültiger Spieler!",
            give = {
                title = "Ped vergeben",
                catalog = "Aus Katalog wählen",
                manual = "Manuelle Eingabe",
                description = "Spieler einen neuen Ped geben",
                manualDesc = "Ped durch Eingabe des Modellnamens vergeben",
                modelLabel = "Ped-Modellname",
                modelPlaceholder = "z.B.: a_c_cat_01",
                pedLabel = "Ped-Anzeigename",
                pedPlaceholder = "z.B.: Katze",
                success = "%s Ped erfolgreich vergeben!",
                alreadyHas = "Dieser Spieler hat diesen Ped bereits!",
                failed = "Beim Vergeben des Peds ist ein Fehler aufgetreten!"
            },
            remove = {
                title = "Ped entfernen",
                description = "Ped vom Spieler entfernen",
                success = "%s Ped erfolgreich entfernt!",
                empty = "Dieser Spieler hat keine Peds"
            },
            list = {
                title = "Peds auflisten",
                description = "Peds des Spielers anzeigen"
            }
        },
        notify = {
            success = "Erfolg",
            error = "Fehler",
            info = "Info",
            applied = "Ped angewendet!",
            reset = "Zum normalen Aussehen zurückgekehrt",
            defaultSet = "Standard-Ped festgelegt!",
            defaultCleared = "Standard-Ped gelöscht",
            pedReceived = "Sie haben Ped %s erhalten!",
            pedRemoved = "Ihr Ped %s wurde entfernt!",
            invalidModel = "Ungültiges Ped-Modell!",
            noPeds = "Sie besitzen keine Peds!",
            alreadyFreemode = "Sie verwenden bereits das normale Aussehen"
        }
    }
}
