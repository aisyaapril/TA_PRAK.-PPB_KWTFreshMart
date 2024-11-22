//import { StrapiRoute } from '@strapi/strapi';

export default {
  routes: [
    {
      method: 'GET',
      path: '/authors/:slug',
      handler: 'author.findOne',
      config: {
        auth: false,
      },
    },
  ],
};
