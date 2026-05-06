Locales["bg"] = {
    UI = {
        modal = {
            save = {
                title = "Запазване на облика",
                description = "Ще продължите с този облик"
            },
            exit = {
                title = "Излизане от персонализацията",
                description = "Промените ви няма да бъдат запазени"
            },
            accept = "Да",
            decline = "Не"
        },
        ped = {
            title = "Персонаж",
            model = "Модел"
        },
        headBlend = {
            title = "Наследство",
            shape = {
                title = "Лице",
                firstOption = "Баща",
                secondOption = "Майка",
                mix = "Смес"
            },
            skin = {
                title = "Кожа",
                firstOption = "Баща",
                secondOption = "Майка",
                mix = "Смес"
            },
            race = {
                title = "Произход",
                shape = "Лице",
                skin = "Кожа",
                mix = "Смес"
            }
        },
        faceFeatures = {
            title = "Черти на лицето",
            nose = {
                title = "Нос",
                width = "Ширина",
                height = "Височина",
                size = "Размер",
                boneHeight = "Височина на костта",
                boneTwist = "Усукване на костта",
                peakHeight = "Височина на върха"
            },
            eyebrows = {
                title = "Вежди",
                height = "Височина",
                depth = "Дълбочина"
            },
            cheeks = {
                title = "Бузи",
                boneHeight = "Височина на костта",
                boneWidth = "Ширина на костта",
                width = "Ширина"
            },
            eyesAndMouth = {
                title = "Очи и уста",
                eyesOpening = "Отваряне на очите",
                lipsThickness = "Дебелина на устните"
            },
            jaw = {
                title = "Челюст",
                width = "Ширина",
                size = "Размер"
            },
            chin = {
                title = "Брадичка",
                lowering = "Спускане",
                length = "Дължина",
                size = "Размер",
                hole = "Размер на трапчинката"
            },
            neck = {
                title = "Шия",
                thickness = "Дебелина"
            }
        },
        headOverlays = {
            title = "Облик",
            hair = {
                title = "Коса",
                style = "Стил",
                color = "Цвят",
                highlight = "Акценти",
                texture = "Текстура",
                fade = "Избледняване"
            },
            opacity = "Прозрачност",
            style = "Стил",
            color = "Цвят",
            secondColor = "Втори цвят",
            blemishes = "Несъвършенства",
            beard = "Брада",
            eyebrows = "Вежди",
            ageing = "Стареене",
            makeUp = "Грим",
            blush = "Руж",
            complexion = "Тен",
            sunDamage = "Слънчеви увреждания",
            lipstick = "Червило",
            moleAndFreckles = "Бенки и лунички",
            chestHair = "Косми на гърдите",
            bodyBlemishes = "Телесни несъвършенства",
            eyeColor = "Цвят на очите"
        },
        components = {
            title = "Дрехи",
            drawable = "Модел",
            texture = "Текстура",
            mask = "Маска",
            upperBody = "Ръце",
            lowerBody = "Крака",
            bags = "Чанта и парашут",
            shoes = "Обувки",
            scarfAndChains = "Шал и вериги",
            shirt = "Риза",
            bodyArmor = "Бронежилетка",
            decals = "Емблеми",
            jackets = "Якета",
            head = "Глава"
        },
        props = {
            title = "Аксесоари",
            drawable = "Модел",
            texture = "Текстура",
            hats = "Шапки и каски",
            glasses = "Очила",
            ear = "Ухо",
            watches = "Часовници",
            bracelets = "Гривни"
        },
        tattoos = {
            title = "Татуировки",
            items = {
                ZONE_TORSO = "Торс",
                ZONE_HEAD = "Глава",
                ZONE_LEFT_ARM = "Лява ръка",
                ZONE_RIGHT_ARM = "Дясна ръка",
                ZONE_LEFT_LEG = "Ляв крак",
                ZONE_RIGHT_LEG = "Десен крак"
            },
            apply = "Приложи",
            applied = "Приложено",
            buy = "Купи",
            delete = "Изтрий",
            deleteAll = "Изтрий всички татуировки",
            opacity = "Прозрачност"
        }
    },

    outfitManagement = {
        title = "Управление на облеклото",
        jobText = "Управление на работни облекла",
        gangText = "Управление на облекла на банда"
    },

    cancelled = {
        title = "Персонализацията е отменена",
        description = "Персонализацията не беше запазена"
    },

    outfits = {
        import = {
            title = "Въведете код на облеклото",
            menuTitle = "Импортиране на облекло",
            description = "Импортирайте облекло с код за споделяне",
            name = {
                label = "Име на облеклото",
                placeholder = "Красива комбинация",
                default = "Импортирано облекло"
            },
            code = {
                label = "Код на облеклото"
            },
            success = {
                title = "Облеклото е импортирано",
                description = "Можете да го смените от менюто за облекла"
            },
            failure = {
                title = "Импортирането е неуспешно",
                description = "Невалиден код на облеклото"
            }
        },
        generate = {
            title = "Генериране на код на облеклото",
            description = "Създайте код на облеклото за споделяне",
            failure = {
                title = "Възникна грешка",
                description = "Кодът на облеклото не може да бъде генериран"
            },
            success = {
                title = "Кодът на облеклото е генериран",
                description = "Вашият код на облеклото е готов"
            }
        },
        save = {
            menuTitle = "Запазване на текущото облекло",
            menuDescription = "Запазете текущото облекло като %s",
            description = "Запазете текущото облекло",
            title = "Име на облеклото",
            managementTitle = "Подробности за управление на облеклото",
            name = {
                label = "Име на облеклото",
                placeholder = "Много готино облекло"
            },
            gender = {
                label = "Пол",
                male = "Мъжки",
                female = "Женски"
            },
            rank = {
                label = "Минимален ранг"
            },
            failure = {
                title = "Запазването е неуспешно",
                description = "Вече съществува облекло с това име"
            },
            success = {
                title = "Успех",
                description = "Облеклото %s е запазено"
            }
        },
        update = {
            title = "Актуализиране на облеклото",
            description = "Запазете текущото облекло върху съществуващо",
            failure = {
                title = "Актуализирането е неуспешно",
                description = "Това облекло не съществува"
            },
            success = {
                title = "Успех",
                description = "Облеклото %s е актуализирано"
            }
        },
        change = {
            title = "Смяна на облеклото",
            description = "Изберете едно от запазените %s облекла",
            pDescription = "Изберете едно от запазените облекла",
            failure = {
                title = "Възникна грешка",
                description = "Избраното облекло няма базов облик"
            }
        },
        delete = {
            title = "Изтриване на облеклото",
            description = "Изтрийте запазено %s облекло",
            mDescription = "Изтрийте едно от запазените облекла",
            item = {
                title = 'Изтриване: "%s"',
                description = "Модел: %s%s"
            },
            success = {
                title = "Успех",
                description = "Облеклото е изтрито"
            }
        },
        manage = {
            title = "👔 | Управление на облекла %s"
        }
    },

    jobOutfits = {
        title = "Работни облекла",
        description = "Изберете едно от работните облекла"
    },

    menu = {
        returnTitle = "Назад",
        title = "Гардероб",
        outfitsTitle = "Облекла на играча",
        clothingShopTitle = "Магазин за дрехи",
        barberShopTitle = "Бръснар",
        tattooShopTitle = "Татуировъчно студио",
        surgeonShopTitle = "Пластичен хирург",
        savedOutfits = "Запазени облекла",
        switchUISide = "Смяна на страна на UI",
        rotateLeft = "Завъртане наляво",
        rotateRight = "Завъртане надясно",
        turnAround = "Обръщане",
        wardrobeSubtitle = "Вашите запазени комбинации",
        wardrobeEmpty = "Няма запазени облекла",
        wardrobeEmptyHint = "Запазете текущото облекло по-долу",
        lightSettings = "Студийно осветление",
        lightSubtitle = "Професионална осветителна система",
        lightPresets = "Бързи предварителни настройки",
        lightIntensity = "Интензивност",
        lightRotation = "Въртене",
        lightHeight = "Височина",
        lightDistance = "Разстояние",
        restoreDefaults = "Възстановяване на настройките по подразбиране",
        toggleLight = "Студийна светлина",
        toggleHandsUp = "Ръце нагоре",
        favorites = "Любими",
        showAll = "Показване на всички",
        showFavorites = "Показване на любими",
        cancelPreload = "Отказване",
        startPreload = "Предварително зареждане",
        loading = "Зареждане",
        synchronizing = "Синхронизиране на ресурсите...",
        preloadPause = "Пауза",
        preloadRestart = "Рестартиране"
    },

    camera = {
        head   = "Глава",
        body   = "Тяло",
        bottom = "Крака",
        default = "Изглед по подразбиране"
    },

    clothing = {
        title = "Купуване на дрехи - $%d",
        titleNoPrice = "Смяна на дрехи",
        options = {
            title = "👔 | Опции на магазина",
            description = "Изберете от голямо разнообразие от артикули"
        },
        outfits = {
            title = "👔 | Опции на облеклото",
            civilian = {
                title = "Гражданско облекло",
                description = "Носете собственото си облекло"
            }
        }
    },

    commands = {
        reloadskin = {
            title = "Презарежда персонажа ви",
            failure = {
                title = "Грешка",
                description = "Не можете да използвате reloadskin сега"
            }
        },
        fixped = {
            title = "Актуализира персонажа ви",
            failure = {
                title = "Грешка",
                description = "Не можете да използвате fixped сега"
            }
        },
        clearstuckprops = {
            title = "Премахва всички заседнали аксесоари",
            failure = {
                title = "Грешка",
                description = "Не можете да използвате clearstuckprops сега"
            }
        },
        pedmenu = {
            title = "Отвори/дай меню за облекло",
            failure = {
                title = "Грешка",
                description = "Играчът не е онлайн"
            }
        },
        joboutfits = {
            title = "Отваря менюто за работни облекла"
        },
        gangoutfits = {
            title = "Отваря менюто за облекла на банда"
        },
        bossmanagedoutfits = {
            title = "Отваря менюто за облекла, управлявани от шефа"
        }
    },

    textUI = {
        clothing = "Магазин за дрехи - Цена: $%d",
        barber = "Бръснар - Цена: $%d",
        tattoo = "Татуировъчно студио - Цена: $%d",
        surgeon = "Пластичен хирург - Цена: $%d",
        clothingRoom = "Съблекалня",
        playerOutfitRoom = "Облекла"
    },

    migrate = {
        success = {
            title = "Успех",
            description = "Миграцията е завършена. %s скина са мигрирани",
            descriptionSingle = "Скинът е мигриран"
        },
        skip = {
            title = "Информация",
            description = "Скинът е пропуснат"
        },
        typeError = {
            title = "Грешка",
            description = "Невалиден тип"
        }
    },

    purchase = {
        tattoo = {
            success = {
                title = "Успех",
                description = "Татуировката %s е купена за $%s"
            },
            failure = {
                title = "Татуировката не може да бъде приложена",
                description = "Недостатъчно пари!"
            }
        },
        store = {
            success = {
                title = "Успех",
                description = "$%s са удържани от %s"
            },
            failure = {
                title = "Плащането е неуспешно",
                description = "Недостатъчно пари!"
            }
        },
        entrance = {
            failure = {
                title = "Не може да влезете в магазина",
                description = "Недостатъчно пари! Нужни са поне $%s в сметката ви."
            }
        }
    },

    peds = {
        commands = {
            pedmenu = "Отваря менюто ви за ped",
            pedadmin = "Дай/премахни ped за играч (Admin)"
        },
        menu = {
            title = "🐾 | Управление на ped",
            myPeds = {
                title = "Моите pedове",
                description = "Преглеждайте и използвайте pedовете си",
                empty = "Все още нямате pedове"
            },
            setDefault = {
                title = "Задаване на ped по подразбиране",
                description = "Изберете ped за автоматично зареждане"
            },
            clearDefault = {
                title = "Изчистване на подразбирането",
                description = "Премахване на настройката за ped по подразбиране"
            },
            reset = {
                title = "Връщане към нормален облик",
                description = "Върнете се към оригиналния си персонаж"
            },
            currentDefault = "⭐ Текущ подразбиращ се"
        },
        admin = {
            title = "🛡️ | Управление на ped — %s",
            customCategory = "Персонализирани pedове",
            invalidPlayer = "Невалиден играч!",
            give = {
                title = "Дай ped",
                catalog = "Избери от каталога",
                manual = "Ръчно въвеждане",
                description = "Дай нов ped на играча",
                manualDesc = "Дай ped чрез въвеждане на името на модела",
                modelLabel = "Име на модела на ped",
                modelPlaceholder = "напр.: a_c_cat_01",
                pedLabel = "Показвано име на ped",
                pedPlaceholder = "напр.: Котка",
                success = "Ped %s е даден успешно!",
                alreadyHas = "Този играч вече има този ped!",
                failed = "Възникна грешка при даването на ped!"
            },
            remove = {
                title = "Премахни ped",
                description = "Премахни ped от играча",
                success = "Ped %s е премахнат успешно!",
                empty = "Този играч няма pedове"
            },
            list = {
                title = "Списък на pedовете",
                description = "Преглед на pedовете на играча"
            }
        },
        notify = {
            success = "Успех",
            error = "Грешка",
            info = "Информация",
            applied = "Ped е приложен!",
            reset = "Върнат към нормален облик",
            defaultSet = "Ped по подразбиране е зададен!",
            defaultCleared = "Ped по подразбиране е изчистен",
            pedReceived = "Получихте ped %s!",
            pedRemoved = "Вашият ped %s беше премахнат!",
            invalidModel = "Невалиден модел на ped!",
            noPeds = "Нямате pedове!",
            alreadyFreemode = "Вече използвате нормалния облик"
        }
    }
}
