Locales["hu"] = {
    UI = {
        modal = {
            save = {
                title = "Megjelenés mentése",
                description = "Ezzel a megjelenéssel folytatja"
            },
            exit = {
                title = "Testreszabás elhagyása",
                description = "A módosítások nem lesznek elmentve"
            },
            accept = "Igen",
            decline = "Nem"
        },
        ped = {
            title = "Karakter",
            model = "Modell"
        },
        headBlend = {
            title = "Örökség",
            shape = {
                title = "Arc",
                firstOption = "Apa",
                secondOption = "Anya",
                mix = "Keverék"
            },
            skin = {
                title = "Bőr",
                firstOption = "Apa",
                secondOption = "Anya",
                mix = "Keverék"
            },
            race = {
                title = "Eredet",
                shape = "Arc",
                skin = "Bőr",
                mix = "Keverék"
            }
        },
        faceFeatures = {
            title = "Arcvonások",
            nose = {
                title = "Orr",
                width = "Szélesség",
                height = "Magasság",
                size = "Méret",
                boneHeight = "Csont magassága",
                boneTwist = "Csont csavarodása",
                peakHeight = "Csúcs magassága"
            },
            eyebrows = {
                title = "Szemöldök",
                height = "Magasság",
                depth = "Mélység"
            },
            cheeks = {
                title = "Arccsontok",
                boneHeight = "Csont magassága",
                boneWidth = "Csont szélessége",
                width = "Szélesség"
            },
            eyesAndMouth = {
                title = "Szemek és száj",
                eyesOpening = "Szemnyílás",
                lipsThickness = "Ajkak vastagsága"
            },
            jaw = {
                title = "Állkapocs",
                width = "Szélesség",
                size = "Méret"
            },
            chin = {
                title = "Áll",
                lowering = "Leengedés",
                length = "Hossz",
                size = "Méret",
                hole = "Gödröcske mérete"
            },
            neck = {
                title = "Nyak",
                thickness = "Vastagság"
            }
        },
        headOverlays = {
            title = "Megjelenés",
            hair = {
                title = "Haj",
                style = "Stílus",
                color = "Szín",
                highlight = "Fényszálak",
                texture = "Textúra",
                fade = "Halványítás"
            },
            opacity = "Átlátszóság",
            style = "Stílus",
            color = "Szín",
            secondColor = "Második szín",
            blemishes = "Bőrhibák",
            beard = "Szakáll",
            eyebrows = "Szemöldök",
            ageing = "Öregedés",
            makeUp = "Smink",
            blush = "Pirosító",
            complexion = "Arcszín",
            sunDamage = "Napkárosodás",
            lipstick = "Rúzs",
            moleAndFreckles = "Anyajegyek és szeplők",
            chestHair = "Mellszőrzet",
            bodyBlemishes = "Testhibák",
            eyeColor = "Szemszín"
        },
        components = {
            title = "Ruházat",
            drawable = "Modell",
            texture = "Textúra",
            mask = "Maszk",
            upperBody = "Karok",
            lowerBody = "Lábak",
            bags = "Táska és ejtőernyő",
            shoes = "Cipők",
            scarfAndChains = "Sál és láncok",
            shirt = "Ing",
            bodyArmor = "Golyóálló mellény",
            decals = "Jelvények",
            jackets = "Kabátok",
            head = "Fej"
        },
        props = {
            title = "Kiegészítők",
            drawable = "Modell",
            texture = "Textúra",
            hats = "Kalapok és sisakok",
            glasses = "Szemüvegek",
            ear = "Fül",
            watches = "Órák",
            bracelets = "Karkötők"
        },
        tattoos = {
            title = "Tetoválások",
            items = {
                ZONE_TORSO = "Törzs",
                ZONE_HEAD = "Fej",
                ZONE_LEFT_ARM = "Bal kar",
                ZONE_RIGHT_ARM = "Jobb kar",
                ZONE_LEFT_LEG = "Bal láb",
                ZONE_RIGHT_LEG = "Jobb láb"
            },
            apply = "Alkalmaz",
            applied = "Alkalmazva",
            buy = "Vásárlás",
            delete = "Törlés",
            deleteAll = "Összes tetoválás törlése",
            opacity = "Átlátszóság"
        }
    },

    outfitManagement = {
        title = "Outfit kezelés",
        jobText = "Munka outfitek kezelése",
        gangText = "Banda outfitek kezelése"
    },

    cancelled = {
        title = "Testreszabás megszakítva",
        description = "A testreszabás nem lett elmentve"
    },

    outfits = {
        import = {
            title = "Outfit kód megadása",
            menuTitle = "Outfit importálása",
            description = "Outfit importálása megosztási kóddal",
            name = {
                label = "Outfit neve",
                placeholder = "Egy szép kombináció",
                default = "Importált outfit"
            },
            code = {
                label = "Outfit kód"
            },
            success = {
                title = "Outfit importálva",
                description = "Megváltoztathatja az outfit menüből"
            },
            failure = {
                title = "Importálás sikertelen",
                description = "Érvénytelen outfit kód"
            }
        },
        generate = {
            title = "Outfit kód generálása",
            description = "Hozzon létre megosztható outfit kódot",
            failure = {
                title = "Hiba történt",
                description = "Az outfit kód nem generálható"
            },
            success = {
                title = "Outfit kód generálva",
                description = "Az outfit kód készen áll"
            }
        },
        save = {
            menuTitle = "Jelenlegi outfit mentése",
            menuDescription = "Jelenlegi outfit mentése %s névvel",
            description = "Jelenlegi outfit mentése",
            title = "Outfit neve",
            managementTitle = "Outfit kezelési adatok",
            name = {
                label = "Outfit neve",
                placeholder = "Nagyon menő outfit"
            },
            gender = {
                label = "Nem",
                male = "Férfi",
                female = "Nő"
            },
            rank = {
                label = "Minimum rang"
            },
            failure = {
                title = "Mentés sikertelen",
                description = "Már létezik ilyen nevű outfit"
            },
            success = {
                title = "Siker",
                description = "%s outfit elmentve"
            }
        },
        update = {
            title = "Outfit frissítése",
            description = "Jelenlegi outfit mentése egy meglévő fölé",
            failure = {
                title = "Frissítés sikertelen",
                description = "Ez az outfit nem létezik"
            },
            success = {
                title = "Siker",
                description = "%s outfit frissítve"
            }
        },
        change = {
            title = "Outfit váltása",
            description = "Válasszon az elmentett %s outfitjei közül",
            pDescription = "Válasszon az elmentett outfitjei közül",
            failure = {
                title = "Hiba történt",
                description = "A kiválasztott outfitnek nincs alapmegjelenése"
            }
        },
        delete = {
            title = "Outfit törlése",
            description = "Mentett %s outfit törlése",
            mDescription = "Egy mentett outfit törlése",
            item = {
                title = 'Törlés: "%s"',
                description = "Modell: %s%s"
            },
            success = {
                title = "Siker",
                description = "Outfit törölve"
            }
        },
        manage = {
            title = "👔 | %s outfitek kezelése"
        }
    },

    jobOutfits = {
        title = "Munka outfitek",
        description = "Válasszon a munka outfitjei közül"
    },

    menu = {
        returnTitle = "Vissza",
        title = "Gardróbszekrény",
        outfitsTitle = "Játékos outfitek",
        clothingShopTitle = "Ruhabolt",
        barberShopTitle = "Borbély",
        tattooShopTitle = "Tetoválószalon",
        surgeonShopTitle = "Plasztikai sebész",
        savedOutfits = "Mentett outfitek",
        switchUISide = "UI oldal váltása",
        rotateLeft = "Balra forgatás",
        rotateRight = "Jobbra forgatás",
        turnAround = "Megfordulás",
        wardrobeSubtitle = "Elmentett kombinációi",
        wardrobeEmpty = "Nincsenek mentett outfitek",
        wardrobeEmptyHint = "Mentse el jelenlegi outfitjét alább",
        lightSettings = "Stúdióvilágítás",
        lightSubtitle = "Professzionális fényrendszer",
        lightPresets = "Gyors előbeállítások",
        lightIntensity = "Intenzitás",
        lightRotation = "Forgatás",
        lightHeight = "Magasság",
        lightDistance = "Távolság",
        restoreDefaults = "Alapértelmezések visszaállítása",
        toggleLight = "Stúdió fény",
        toggleHandsUp = "Kezek fel",
        favorites = "Kedvencek",
        showAll = "Összes mutatása",
        showFavorites = "Kedvencek mutatása",
        cancelPreload = "Mégse",
        startPreload = "Előtöltés",
        loading = "Betöltés",
        synchronizing = "Erőforrások szinkronizálása...",
        preloadPause = "Szünet",
        preloadRestart = "Újraindítás"
    },

    camera = {
        head   = "Fej",
        body   = "Test",
        bottom = "Lábak",
        default = "Alapértelmezett nézet"
    },

    clothing = {
        title = "Ruha vásárlása - $%d",
        titleNoPrice = "Ruha váltása",
        options = {
            title = "👔 | Bolt lehetőségek",
            description = "Válasszon a széles ruhaválasztékból"
        },
        outfits = {
            title = "👔 | Outfit lehetőségek",
            civilian = {
                title = "Polgári outfit",
                description = "Viselje saját outfitjét"
            }
        }
    },

    commands = {
        reloadskin = {
            title = "Újratölti a karaktert",
            failure = {
                title = "Hiba",
                description = "A reloadskin most nem használható"
            }
        },
        fixped = {
            title = "Frissíti a karaktert",
            failure = {
                title = "Hiba",
                description = "A fixped most nem használható"
            }
        },
        clearstuckprops = {
            title = "Eltávolítja az összes elakadt kiegészítőt",
            failure = {
                title = "Hiba",
                description = "A clearstuckprops most nem használható"
            }
        },
        pedmenu = {
            title = "Outfit menü megnyitása/adása",
            failure = {
                title = "Hiba",
                description = "A játékos nincs online"
            }
        },
        joboutfits = {
            title = "Megnyitja a munka outfit menüt"
        },
        gangoutfits = {
            title = "Megnyitja a banda outfit menüt"
        },
        bossmanagedoutfits = {
            title = "Megnyitja a főnök által kezelt outfit menüt"
        }
    },

    textUI = {
        clothing = "Ruhabolt - Ár: $%d",
        barber = "Borbély - Ár: $%d",
        tattoo = "Tetoválószalon - Ár: $%d",
        surgeon = "Plasztikai sebész - Ár: $%d",
        clothingRoom = "Öltöző",
        playerOutfitRoom = "Outfitek"
    },

    migrate = {
        success = {
            title = "Siker",
            description = "Migráció befejezve. %s skin migrálva",
            descriptionSingle = "Skin migrálva"
        },
        skip = {
            title = "Info",
            description = "Skin kihagyva"
        },
        typeError = {
            title = "Hiba",
            description = "Érvénytelen típus"
        }
    },

    purchase = {
        tattoo = {
            success = {
                title = "Siker",
                description = "%s tetoválás megvásárolva $%s-ért"
            },
            failure = {
                title = "A tetoválás nem alkalmazható",
                description = "Nincs elég pénz!"
            }
        },
        store = {
            success = {
                title = "Siker",
                description = "$%s levonva %s-tól"
            },
            failure = {
                title = "Fizetés sikertelen",
                description = "Nincs elég pénz!"
            }
        },
        entrance = {
            failure = {
                title = "Nem lehet belépni a boltba",
                description = "Nincs elég pénz! Legalább $%s szükséges a bankszámlán."
            }
        }
    },

    peds = {
        commands = {
            pedmenu = "Megnyitja a ped menüt",
            pedadmin = "Ped adása/elvétele játékosnak (Admin)"
        },
        menu = {
            title = "🐾 | Ped kezelés",
            myPeds = {
                title = "Saját pedeim",
                description = "Pedek megtekintése és használata",
                empty = "Még nincs egy ped sem"
            },
            setDefault = {
                title = "Alapértelmezett ped beállítása",
                description = "Válasszon automatikusan betöltendő pedet"
            },
            clearDefault = {
                title = "Alapértelmezett törlése",
                description = "Alapértelmezett ped beállítás eltávolítása"
            },
            reset = {
                title = "Visszatérés normál megjelenéshez",
                description = "Visszatérés az eredeti karakterhez"
            },
            currentDefault = "⭐ Jelenlegi alapértelmezett"
        },
        admin = {
            title = "🛡️ | Ped kezelés — %s",
            customCategory = "Egyéni pedek",
            invalidPlayer = "Érvénytelen játékos!",
            give = {
                title = "Ped adása",
                catalog = "Választás katalógusból",
                manual = "Manuális bevitel",
                description = "Új ped adása a játékosnak",
                manualDesc = "Ped adása modell neve megadásával",
                modelLabel = "Ped modell neve",
                modelPlaceholder = "pl.: a_c_cat_01",
                pedLabel = "Ped megjelenítési neve",
                pedPlaceholder = "pl.: Macska",
                success = "%s ped sikeresen adva!",
                alreadyHas = "Ennek a játékosnak már megvan ez a ped!",
                failed = "Hiba történt a ped adásakor!"
            },
            remove = {
                title = "Ped elvétele",
                description = "Ped elvétele a játékostól",
                success = "%s ped sikeresen elvéve!",
                empty = "Ennek a játékosnak nincsenek pedei"
            },
            list = {
                title = "Pedek listázása",
                description = "Játékos pedjeinek megtekintése"
            }
        },
        notify = {
            success = "Siker",
            error = "Hiba",
            info = "Info",
            applied = "Ped alkalmazva!",
            reset = "Visszatért a normál megjelenéshez",
            defaultSet = "Alapértelmezett ped beállítva!",
            defaultCleared = "Alapértelmezett ped törölve",
            pedReceived = "%s pedet kapott!",
            pedRemoved = "%s ped eltávolítva!",
            invalidModel = "Érvénytelen ped modell!",
            noPeds = "Nincsenek pedei!",
            alreadyFreemode = "Már a normál megjelenést használja"
        }
    }
}
