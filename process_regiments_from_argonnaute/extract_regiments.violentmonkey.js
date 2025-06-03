// ==UserScript==
// @name        argonnaute : extract document ids
// @namespace   Violentmonkey Scripts
// @match       https://argonnaute.parisnanterre.fr/ark:/14707/*
// @grant       none
// @version     1.0
// @author      -
// @description 6/2/2025, 6:49:04 PM
// Get the IDs of all battalion histories as well as the number of media items in each document.
// The list is stored inside regiments_list.json.
// ==/UserScript==


(function () {
    'use strict';

    function sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    window.extracted_data = [];
    window.not_found_for = [];

    async function main() {
        await sleep(5000);

        const links = Array.from(document.querySelectorAll(
            'li.leaf[style*="padding-left: 50px;"] > a[title*="régiment d\'infanterie"]'
        ));

        for (let i = 0; i < links.length; i++) {
            const link = links[i];
            link.click();

            await sleep(600);

            const arkLink = document.querySelector('a[href*="/ark:/"]');
            let arkId = null;
            if (arkLink) {
                const href = arkLink.getAttribute('href') || '';
                const match = href.match(/\/ark:\/[^/]+\/([^/]+)/);
                if (match && match[1]) {
                    arkId = match[1];
                }
            } else {
                window.not_found_for.push(link.getAttribute('title'));
                console.log(`❌ No ark:/ link found after click "${link.getAttribute('title')}".`);
            }

            // Extract media numbers
            let nb_medias = 0;
            const span = document.querySelector('p > span');
            if (span) {
                const mediaMatch = span.textContent.match(/(\d+)\s+medias?/i);
                if (mediaMatch) {
                    nb_medias = parseInt(mediaMatch[1], 10);
                }
            }

            if (arkId) {
                window.extracted_data.push({
                    title: link.getAttribute('title'),
                    ark_name: arkId,
                    nb_medias: nb_medias
                });
            }

            await sleep(500);
        }

        console.log('Extraction terminée');
    }

    main();
})();