//import { StrapiRoute } from '@strapi/strapi';

export default {
    routes: [
        {
            method: 'GET',
            path: '/homes/:slug',
            handler: 'home.findOne',
            config: {
              auth: false,
            },
        },
    ],
};
  