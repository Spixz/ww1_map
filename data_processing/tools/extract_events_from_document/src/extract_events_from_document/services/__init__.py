from .events_service import (
    storeEventsIbDb,
    getEventsInDbFromPages,
    deleteEventsInDb,
    printEvents,
    preareEventsForStorage,
)

from .regiments_service import (
    getRegimentIdByName,
    createRegimentIdentityCardIfNotExist,
)
