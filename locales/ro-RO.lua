Locales["ro-RO"] = {
    UI = {
        modal = {
            save = {
                title = "Salvare aspect",
                description = "Vei continua cu acest aspect"
            },
            exit = {
                title = "Ieșire din personalizare",
                description = "Modificările tale nu vor fi salvate"
            },
            accept = "Da",
            decline = "Nu"
        },
        ped = {
            title = "Personaj",
            model = "Model"
        },
        headBlend = {
            title = "Moștenire",
            shape = {
                title = "Față",
                firstOption = "Tată",
                secondOption = "Mamă",
                mix = "Amestec"
            },
            skin = {
                title = "Ten",
                firstOption = "Tată",
                secondOption = "Mamă",
                mix = "Amestec"
            },
            race = {
                title = "Origine",
                shape = "Față",
                skin = "Ten",
                mix = "Amestec"
            }
        },
        faceFeatures = {
            title = "Trăsături faciale",
            nose = {
                title = "Nas",
                width = "Lățime",
                height = "Înălțime",
                size = "Mărime",
                boneHeight = "Înălțimea osului",
                boneTwist = "Răsucirea osului",
                peakHeight = "Înălțimea vârfului"
            },
            eyebrows = {
                title = "Sprâncene",
                height = "Înălțime",
                depth = "Adâncime"
            },
            cheeks = {
                title = "Obraji",
                boneHeight = "Înălțimea osului",
                boneWidth = "Lățimea osului",
                width = "Lățime"
            },
            eyesAndMouth = {
                title = "Ochi și gură",
                eyesOpening = "Deschiderea ochilor",
                lipsThickness = "Grosimea buzelor"
            },
            jaw = {
                title = "Maxilar",
                width = "Lățime",
                size = "Mărime"
            },
            chin = {
                title = "Bărbie",
                lowering = "Coborâre",
                length = "Lungime",
                size = "Mărime",
                hole = "Mărimea gropiței"
            },
            neck = {
                title = "Gât",
                thickness = "Grosime"
            }
        },
        headOverlays = {
            title = "Aspect",
            hair = {
                title = "Păr",
                style = "Stil",
                color = "Culoare",
                highlight = "Reflexe",
                texture = "Textură",
                fade = "Degradé"
            },
            opacity = "Opacitate",
            style = "Stil",
            color = "Culoare",
            secondColor = "A doua culoare",
            blemishes = "Imperfecțiuni",
            beard = "Barbă",
            eyebrows = "Sprâncene",
            ageing = "Îmbătrânire",
            makeUp = "Machiaj",
            blush = "Fard",
            complexion = "Tenul",
            sunDamage = "Deteriorare solară",
            lipstick = "Ruj",
            moleAndFreckles = "Alunițe și pistrui",
            chestHair = "Păr pe piept",
            bodyBlemishes = "Imperfecțiuni corporale",
            eyeColor = "Culoarea ochilor"
        },
        components = {
            title = "Îmbrăcăminte",
            drawable = "Model",
            texture = "Textură",
            mask = "Mască",
            upperBody = "Brațe",
            lowerBody = "Picioare",
            bags = "Geantă și parașută",
            shoes = "Pantofi",
            scarfAndChains = "Eșarfă și lanțuri",
            shirt = "Tricou",
            bodyArmor = "Vestă antiglonț",
            decals = "Insigne",
            jackets = "Jachete",
            head = "Cap"
        },
        props = {
            title = "Accesorii",
            drawable = "Model",
            texture = "Textură",
            hats = "Pălării și căști",
            glasses = "Ochelari",
            ear = "Ureche",
            watches = "Ceasuri",
            bracelets = "Brățări"
        },
        tattoos = {
            title = "Tatuaje",
            items = {
                ZONE_TORSO = "Trunchi",
                ZONE_HEAD = "Cap",
                ZONE_LEFT_ARM = "Brațul stâng",
                ZONE_RIGHT_ARM = "Brațul drept",
                ZONE_LEFT_LEG = "Piciorul stâng",
                ZONE_RIGHT_LEG = "Piciorul drept"
            },
            apply = "Aplică",
            applied = "Aplicat",
            buy = "Cumpără",
            delete = "Șterge",
            deleteAll = "Șterge toate tatuajele",
            opacity = "Opacitate"
        }
    },

    outfitManagement = {
        title = "Gestionare ținute",
        jobText = "Gestionare ținute de serviciu",
        gangText = "Gestionare ținute de bandă"
    },

    cancelled = {
        title = "Personalizare anulată",
        description = "Personalizarea nu a fost salvată"
    },

    outfits = {
        import = {
            title = "Introduceți codul ținutei",
            menuTitle = "Importare ținută",
            description = "Importați o ținută cu un cod de partajare",
            name = {
                label = "Numele ținutei",
                placeholder = "O combinație frumoasă",
                default = "Ținută importată"
            },
            code = {
                label = "Codul ținutei"
            },
            success = {
                title = "Ținută importată",
                description = "O poți schimba din meniul de ținute"
            },
            failure = {
                title = "Import eșuat",
                description = "Cod de ținută invalid"
            }
        },
        generate = {
            title = "Generare cod ținută",
            description = "Creați un cod de ținută pentru partajare",
            failure = {
                title = "A apărut o eroare",
                description = "Codul ținutei nu poate fi generat"
            },
            success = {
                title = "Cod ținută generat",
                description = "Codul tău de ținută este gata"
            }
        },
        save = {
            menuTitle = "Salvare ținută curentă",
            menuDescription = "Salvați ținuta curentă ca %s",
            description = "Salvați ținuta curentă",
            title = "Numele ținutei",
            managementTitle = "Detalii gestionare ținută",
            name = {
                label = "Numele ținutei",
                placeholder = "Ținută foarte tare"
            },
            gender = {
                label = "Gen",
                male = "Masculin",
                female = "Feminin"
            },
            rank = {
                label = "Rang minim"
            },
            failure = {
                title = "Salvare eșuată",
                description = "Există deja o ținută cu acest nume"
            },
            success = {
                title = "Succes",
                description = "Ținuta %s salvată"
            }
        },
        update = {
            title = "Actualizare ținută",
            description = "Salvați ținuta curentă peste una existentă",
            failure = {
                title = "Actualizare eșuată",
                description = "Această ținută nu există"
            },
            success = {
                title = "Succes",
                description = "Ținuta %s actualizată"
            }
        },
        change = {
            title = "Schimbare ținută",
            description = "Selectați una dintre ținutele %s salvate",
            pDescription = "Selectați una dintre ținutele salvate",
            failure = {
                title = "A apărut o eroare",
                description = "Ținuta selectată nu are aspect de bază"
            }
        },
        delete = {
            title = "Ștergere ținută",
            description = "Ștergeți o ținută %s salvată",
            mDescription = "Ștergeți una dintre ținutele salvate",
            item = {
                title = 'Ștergere: "%s"',
                description = "Model: %s%s"
            },
            success = {
                title = "Succes",
                description = "Ținută ștearsă"
            }
        },
        manage = {
            title = "👔 | Gestionare ținute %s"
        }
    },

    jobOutfits = {
        title = "Ținute de serviciu",
        description = "Alegeți una dintre ținutele de serviciu"
    },

    menu = {
        returnTitle = "Înapoi",
        title = "Garderobă",
        outfitsTitle = "Ținute jucător",
        clothingShopTitle = "Magazin de haine",
        barberShopTitle = "Frizer",
        tattooShopTitle = "Studio de tatuaje",
        surgeonShopTitle = "Chirurg plastic",
        savedOutfits = "Ținute salvate",
        switchUISide = "Schimbare parte UI",
        rotateLeft = "Rotire stânga",
        rotateRight = "Rotire dreapta",
        turnAround = "Întoarcere",
        wardrobeSubtitle = "Combinațiile tale salvate",
        wardrobeEmpty = "Nicio ținută salvată",
        wardrobeEmptyHint = "Salvați ținuta curentă mai jos",
        lightSettings = "Iluminare studio",
        lightSubtitle = "Sistem de iluminare profesional",
        lightPresets = "Presetări rapide",
        lightIntensity = "Intensitate",
        lightRotation = "Rotație",
        lightHeight = "Înălțime",
        lightDistance = "Distanță",
        restoreDefaults = "Restaurare setări implicite",
        toggleLight = "Lumină studio",
        toggleHandsUp = "Mâini sus",
        favorites = "Favorite",
        showAll = "Arată tot",
        showFavorites = "Arată favorite",
        cancelPreload = "Anulare",
        startPreload = "Preîncărcare",
        loading = "Se încarcă",
        synchronizing = "Sincronizare resurse...",
        preloadPause = "Pauză",
        preloadRestart = "Repornire"
    },

    camera = {
        head   = "Cap",
        body   = "Corp",
        bottom = "Picioare",
        default = "Vedere implicită"
    },

    clothing = {
        title = "Cumpărare haine - $%d",
        titleNoPrice = "Schimbare haine",
        options = {
            title = "👔 | Opțiuni magazin",
            description = "Alegeți dintr-o gamă largă de articole"
        },
        outfits = {
            title = "👔 | Opțiuni ținută",
            civilian = {
                title = "Ținută civilă",
                description = "Purtați propria ținută"
            }
        }
    },

    commands = {
        reloadskin = {
            title = "Reîncarcă personajul tău",
            failure = {
                title = "Eroare",
                description = "Nu poți folosi reloadskin acum"
            }
        },
        fixped = {
            title = "Actualizează personajul tău",
            failure = {
                title = "Eroare",
                description = "Nu poți folosi fixped acum"
            }
        },
        clearstuckprops = {
            title = "Elimină toate accesoriile blocate",
            failure = {
                title = "Eroare",
                description = "Nu poți folosi clearstuckprops acum"
            }
        },
        pedmenu = {
            title = "Deschide/Dă meniu ținută",
            failure = {
                title = "Eroare",
                description = "Jucătorul nu este online"
            }
        },
        joboutfits = {
            title = "Deschide meniul ținutelor de serviciu"
        },
        gangoutfits = {
            title = "Deschide meniul ținutelor de bandă"
        },
        bossmanagedoutfits = {
            title = "Deschide meniul ținutelor gestionate de șef"
        }
    },

    textUI = {
        clothing = "Magazin de haine - Cost: $%d",
        barber = "Frizer - Cost: $%d",
        tattoo = "Studio de tatuaje - Cost: $%d",
        surgeon = "Chirurg plastic - Cost: $%d",
        clothingRoom = "Vestiar",
        playerOutfitRoom = "Ținute"
    },

    migrate = {
        success = {
            title = "Succes",
            description = "Migrare finalizată. %s skin-uri migrate",
            descriptionSingle = "Skin migrat"
        },
        skip = {
            title = "Info",
            description = "Skin omis"
        },
        typeError = {
            title = "Eroare",
            description = "Tip invalid"
        }
    },

    purchase = {
        tattoo = {
            success = {
                title = "Succes",
                description = "Tatuaj %s cumpărat cu $%s"
            },
            failure = {
                title = "Tatuajul nu a putut fi aplicat",
                description = "Bani insuficienți!"
            }
        },
        store = {
            success = {
                title = "Succes",
                description = "$%s a fost debitat din contul lui %s"
            },
            failure = {
                title = "Plată eșuată",
                description = "Bani insuficienți!"
            }
        },
        entrance = {
            failure = {
                title = "Nu se poate intra în magazin",
                description = "Bani insuficienți! Ai nevoie de cel puțin $%s în cont."
            }
        }
    },

    peds = {
        commands = {
            pedmenu = "Deschide meniul tău de ped",
            pedadmin = "Dă/elimină ped pentru jucător (Admin)"
        },
        menu = {
            title = "🐾 | Gestionare ped",
            myPeds = {
                title = "Pedii mei",
                description = "Vizualizează și folosește pedii deținuți",
                empty = "Nu dețineți încă niciun ped"
            },
            setDefault = {
                title = "Setare ped implicit",
                description = "Selectați un ped pentru încărcare automată"
            },
            clearDefault = {
                title = "Ștergere implicit",
                description = "Eliminare setare ped implicit"
            },
            reset = {
                title = "Revenire la aspect normal",
                description = "Reveniți la personajul original"
            },
            currentDefault = "⭐ Implicit curent"
        },
        admin = {
            title = "🛡️ | Gestionare ped — %s",
            customCategory = "Pedi personalizați",
            invalidPlayer = "Jucător invalid!",
            give = {
                title = "Dă ped",
                catalog = "Alege din catalog",
                manual = "Introducere manuală",
                description = "Dă un ped nou jucătorului",
                manualDesc = "Dă ped introducând numele modelului",
                modelLabel = "Numele modelului ped",
                modelPlaceholder = "ex: a_c_cat_01",
                pedLabel = "Numele de afișare al pedului",
                pedPlaceholder = "ex: Pisică",
                success = "Ped %s dat cu succes!",
                alreadyHas = "Acest jucător are deja acest ped!",
                failed = "A apărut o eroare la darea pedului!"
            },
            remove = {
                title = "Elimină ped",
                description = "Elimină ped de la jucător",
                success = "Ped %s eliminat cu succes!",
                empty = "Acest jucător nu are pedi"
            },
            list = {
                title = "Listare pedi",
                description = "Vizualizează pedii jucătorului"
            }
        },
        notify = {
            success = "Succes",
            error = "Eroare",
            info = "Info",
            applied = "Ped aplicat!",
            reset = "Revenit la aspect normal",
            defaultSet = "Ped implicit setat!",
            defaultCleared = "Ped implicit șters",
            pedReceived = "Ai primit pedul %s!",
            pedRemoved = "Pedul tău %s a fost eliminat!",
            invalidModel = "Model ped invalid!",
            noPeds = "Nu dețineți niciun ped!",
            alreadyFreemode = "Folosești deja aspectul normal"
        }
    }
}
