Locales["cs"] = {
    UI = {
        modal = {
            save = {
                title = "Uložit vzhled",
                description = "Pokračujete s tímto vzhledem"
            },
            exit = {
                title = "Opustit přizpůsobení",
                description = "Vaše změny nebudou uloženy"
            },
            accept = "Ano",
            decline = "Ne"
        },
        ped = {
            title = "Postava",
            model = "Model"
        },
        headBlend = {
            title = "Dědičnost",
            shape = {
                title = "Obličej",
                firstOption = "Otec",
                secondOption = "Matka",
                mix = "Mix"
            },
            skin = {
                title = "Pleť",
                firstOption = "Otec",
                secondOption = "Matka",
                mix = "Mix"
            },
            race = {
                title = "Původ",
                shape = "Obličej",
                skin = "Pleť",
                mix = "Mix"
            }
        },
        faceFeatures = {
            title = "Rysy obličeje",
            nose = {
                title = "Nos",
                width = "Šířka",
                height = "Výška",
                size = "Velikost",
                boneHeight = "Výška kosti",
                boneTwist = "Zkroucení kosti",
                peakHeight = "Výška špičky"
            },
            eyebrows = {
                title = "Obočí",
                height = "Výška",
                depth = "Hloubka"
            },
            cheeks = {
                title = "Tváře",
                boneHeight = "Výška kosti",
                boneWidth = "Šířka kosti",
                width = "Šířka"
            },
            eyesAndMouth = {
                title = "Oči a ústa",
                eyesOpening = "Otevření očí",
                lipsThickness = "Tloušťka rtů"
            },
            jaw = {
                title = "Čelist",
                width = "Šířka",
                size = "Velikost"
            },
            chin = {
                title = "Brada",
                lowering = "Snížení",
                length = "Délka",
                size = "Velikost",
                hole = "Velikost důlku"
            },
            neck = {
                title = "Krk",
                thickness = "Tloušťka"
            }
        },
        headOverlays = {
            title = "Vzhled",
            hair = {
                title = "Vlasy",
                style = "Styl",
                color = "Barva",
                highlight = "Odlesky",
                texture = "Textura",
                fade = "Přechod"
            },
            opacity = "Průhlednost",
            style = "Styl",
            color = "Barva",
            secondColor = "Druhá barva",
            blemishes = "Nedokonalosti",
            beard = "Vous",
            eyebrows = "Obočí",
            ageing = "Stárnutí",
            makeUp = "Make-up",
            blush = "Tvářenka",
            complexion = "Tón pleti",
            sunDamage = "Poškození sluncem",
            lipstick = "Rtěnka",
            moleAndFreckles = "Mateřská znaménka a pihy",
            chestHair = "Ochlupení hrudníku",
            bodyBlemishes = "Tělesné nedokonalosti",
            eyeColor = "Barva očí"
        },
        components = {
            title = "Oblečení",
            drawable = "Model",
            texture = "Textura",
            mask = "Maska",
            upperBody = "Paže",
            lowerBody = "Nohy",
            bags = "Taška a padák",
            shoes = "Boty",
            scarfAndChains = "Šála a řetězy",
            shirt = "Tričko",
            bodyArmor = "Neprůstřelná vesta",
            decals = "Odznaky",
            jackets = "Bundy",
            head = "Hlava"
        },
        props = {
            title = "Doplňky",
            drawable = "Model",
            texture = "Textura",
            hats = "Klobouky a helmy",
            glasses = "Brýle",
            ear = "Ucho",
            watches = "Hodinky",
            bracelets = "Náramky"
        },
        tattoos = {
            title = "Tetování",
            items = {
                ZONE_TORSO = "Trup",
                ZONE_HEAD = "Hlava",
                ZONE_LEFT_ARM = "Levá paže",
                ZONE_RIGHT_ARM = "Pravá paže",
                ZONE_LEFT_LEG = "Levá noha",
                ZONE_RIGHT_LEG = "Pravá noha"
            },
            apply = "Použít",
            applied = "Použito",
            buy = "Koupit",
            delete = "Smazat",
            deleteAll = "Smazat všechna tetování",
            opacity = "Průhlednost"
        }
    },

    outfitManagement = {
        title = "Správa outfitů",
        jobText = "Spravovat pracovní outfity",
        gangText = "Spravovat gangové outfity"
    },

    cancelled = {
        title = "Přizpůsobení zrušeno",
        description = "Přizpůsobení nebylo uloženo"
    },

    outfits = {
        import = {
            title = "Zadat kód outfitu",
            menuTitle = "Importovat outfit",
            description = "Importujte outfit pomocí sdíleného kódu",
            name = {
                label = "Název outfitu",
                placeholder = "Pěkná kombinace",
                default = "Importovaný outfit"
            },
            code = {
                label = "Kód outfitu"
            },
            success = {
                title = "Outfit importován",
                description = "Můžete ho změnit přes menu outfitů"
            },
            failure = {
                title = "Import selhal",
                description = "Neplatný kód outfitu"
            }
        },
        generate = {
            title = "Generovat kód outfitu",
            description = "Vytvořte kód outfitu ke sdílení",
            failure = {
                title = "Došlo k chybě",
                description = "Kód outfitu nelze vygenerovat"
            },
            success = {
                title = "Kód outfitu vygenerován",
                description = "Váš kód outfitu je připraven"
            }
        },
        save = {
            menuTitle = "Uložit aktuální outfit",
            menuDescription = "Uložit váš aktuální outfit jako %s",
            description = "Uložit váš aktuální outfit",
            title = "Název outfitu",
            managementTitle = "Podrobnosti správy outfitu",
            name = {
                label = "Název outfitu",
                placeholder = "Velmi cool outfit"
            },
            gender = {
                label = "Pohlaví",
                male = "Mužský",
                female = "Ženský"
            },
            rank = {
                label = "Minimální hodnost"
            },
            failure = {
                title = "Uložení selhalo",
                description = "Outfit s tímto názvem již existuje"
            },
            success = {
                title = "Úspěch",
                description = "Outfit %s uložen"
            }
        },
        update = {
            title = "Aktualizovat outfit",
            description = "Uložit aktuální outfit přes existující",
            failure = {
                title = "Aktualizace selhala",
                description = "Tento outfit neexistuje"
            },
            success = {
                title = "Úspěch",
                description = "Outfit %s aktualizován"
            }
        },
        change = {
            title = "Změnit outfit",
            description = "Vyberte jeden z vašich uložených %s outfitů",
            pDescription = "Vyberte jeden z vašich uložených outfitů",
            failure = {
                title = "Došlo k chybě",
                description = "Vybraný outfit nemá základní vzhled"
            }
        },
        delete = {
            title = "Smazat outfit",
            description = "Smazat uložený %s outfit",
            mDescription = "Smazat jeden z vašich uložených outfitů",
            item = {
                title = 'Smazat: "%s"',
                description = "Model: %s%s"
            },
            success = {
                title = "Úspěch",
                description = "Outfit smazán"
            }
        },
        manage = {
            title = "👔 | Spravovat outfity %s"
        }
    },

    jobOutfits = {
        title = "Pracovní outfity",
        description = "Vyberte jeden z vašich pracovních outfitů"
    },

    menu = {
        returnTitle = "Zpět",
        title = "Šatník",
        outfitsTitle = "Outfity hráče",
        clothingShopTitle = "Obchod s oblečením",
        barberShopTitle = "Holič",
        tattooShopTitle = "Tetovací studio",
        surgeonShopTitle = "Plastický chirurg",
        savedOutfits = "Uložené outfity",
        switchUISide = "Přepnout stranu UI",
        rotateLeft = "Otočit doleva",
        rotateRight = "Otočit doprava",
        turnAround = "Otočit se",
        wardrobeSubtitle = "Vaše uložené kombinace",
        wardrobeEmpty = "Žádné uložené outfity",
        wardrobeEmptyHint = "Uložte svůj aktuální outfit níže",
        lightSettings = "Studiové osvětlení",
        lightSubtitle = "Profesionální světelný systém",
        lightPresets = "Rychlé předvolby",
        lightIntensity = "Intenzita",
        lightRotation = "Rotace",
        lightHeight = "Výška",
        lightDistance = "Vzdálenost",
        restoreDefaults = "Obnovit výchozí nastavení",
        toggleLight = "Studiové světlo",
        toggleHandsUp = "Ruce nahoru",
        favorites = "Oblíbené",
        showAll = "Zobrazit vše",
        showFavorites = "Zobrazit oblíbené",
        cancelPreload = "Zrušit",
        startPreload = "Přednahrát",
        loading = "Načítání",
        synchronizing = "Synchronizace prostředků...",
        preloadPause = "Pozastavit",
        preloadRestart = "Restartovat"
    },

    camera = {
        head   = "Hlava",
        body   = "Tělo",
        bottom = "Nohy",
        default = "Výchozí pohled"
    },

    clothing = {
        title = "Koupit oblečení - $%d",
        titleNoPrice = "Změnit oblečení",
        options = {
            title = "👔 | Možnosti obchodu",
            description = "Vyberte z velké řady oblečení"
        },
        outfits = {
            title = "👔 | Možnosti outfitu",
            civilian = {
                title = "Civilní outfit",
                description = "Noste svůj vlastní outfit"
            }
        }
    },

    commands = {
        reloadskin = {
            title = "Znovu načte vaši postavu",
            failure = {
                title = "Chyba",
                description = "Nemůžete nyní použít reloadskin"
            }
        },
        fixped = {
            title = "Aktualizuje vaši postavu",
            failure = {
                title = "Chyba",
                description = "Nemůžete nyní použít fixped"
            }
        },
        clearstuckprops = {
            title = "Odstraní všechny zaseknuté doplňky",
            failure = {
                title = "Chyba",
                description = "Nemůžete nyní použít clearstuckprops"
            }
        },
        pedmenu = {
            title = "Otevřít/dát menu outfitu",
            failure = {
                title = "Chyba",
                description = "Hráč není online"
            }
        },
        joboutfits = {
            title = "Otevře menu pracovních outfitů"
        },
        gangoutfits = {
            title = "Otevře menu gangových outfitů"
        },
        bossmanagedoutfits = {
            title = "Otevře menu outfitů spravovaných šéfem"
        }
    },

    textUI = {
        clothing = "Obchod s oblečením - Cena: $%d",
        barber = "Holič - Cena: $%d",
        tattoo = "Tetovací studio - Cena: $%d",
        surgeon = "Plastický chirurg - Cena: $%d",
        clothingRoom = "Šatna",
        playerOutfitRoom = "Outfity"
    },

    migrate = {
        success = {
            title = "Úspěch",
            description = "Migrace dokončena. %s skinů migrováno",
            descriptionSingle = "Skin migrován"
        },
        skip = {
            title = "Info",
            description = "Skin přeskočen"
        },
        typeError = {
            title = "Chyba",
            description = "Neplatný typ"
        }
    },

    purchase = {
        tattoo = {
            success = {
                title = "Úspěch",
                description = "Tetování %s koupeno za $%s"
            },
            failure = {
                title = "Tetování nelze použít",
                description = "Nedostatek peněz!"
            }
        },
        store = {
            success = {
                title = "Úspěch",
                description = "$%s bylo účtováno %s"
            },
            failure = {
                title = "Platba selhala",
                description = "Nedostatek peněz!"
            }
        },
        entrance = {
            failure = {
                title = "Nelze vstoupit do obchodu",
                description = "Nedostatek peněz! Potřebujete alespoň $%s na svém účtu."
            }
        }
    },

    peds = {
        commands = {
            pedmenu = "Otevře vaše ped menu",
            pedadmin = "Dát/odebrat ped hráči (Admin)"
        },
        menu = {
            title = "🐾 | Správa pedů",
            myPeds = {
                title = "Moje pedy",
                description = "Prohlédněte a použijte vaše pedy",
                empty = "Zatím nevlastníte žádné pedy"
            },
            setDefault = {
                title = "Nastavit výchozí ped",
                description = "Vyberte ped k automatickému načítání"
            },
            clearDefault = {
                title = "Vymazat výchozí",
                description = "Odstranit nastavení výchozího pedu"
            },
            reset = {
                title = "Vrátit se k normálnímu vzhledu",
                description = "Vraťte se ke své původní postavě"
            },
            currentDefault = "⭐ Aktuální výchozí"
        },
        admin = {
            title = "🛡️ | Správa pedů — %s",
            customCategory = "Vlastní pedy",
            invalidPlayer = "Neplatný hráč!",
            give = {
                title = "Dát ped",
                catalog = "Vybrat z katalogu",
                manual = "Ruční zadání",
                description = "Dát hráči nový ped",
                manualDesc = "Dát ped zadáním názvu modelu",
                modelLabel = "Název modelu pedu",
                modelPlaceholder = "např.: a_c_cat_01",
                pedLabel = "Zobrazované jméno pedu",
                pedPlaceholder = "např.: Kočka",
                success = "Ped %s úspěšně dán!",
                alreadyHas = "Tento hráč již tento ped má!",
                failed = "Při dávání pedu došlo k chybě!"
            },
            remove = {
                title = "Odebrat ped",
                description = "Odebrat ped hráči",
                success = "Ped %s úspěšně odebrán!",
                empty = "Tento hráč nemá žádné pedy"
            },
            list = {
                title = "Seznam pedů",
                description = "Zobrazit pedy hráče"
            }
        },
        notify = {
            success = "Úspěch",
            error = "Chyba",
            info = "Info",
            applied = "Ped použit!",
            reset = "Vrácen k normálnímu vzhledu",
            defaultSet = "Výchozí ped nastaven!",
            defaultCleared = "Výchozí ped vymazán",
            pedReceived = "Obdrželi jste ped %s!",
            pedRemoved = "Váš ped %s byl odebrán!",
            invalidModel = "Neplatný model pedu!",
            noPeds = "Nevlastníte žádné pedy!",
            alreadyFreemode = "Již používáte normální vzhled"
        }
    }
}
