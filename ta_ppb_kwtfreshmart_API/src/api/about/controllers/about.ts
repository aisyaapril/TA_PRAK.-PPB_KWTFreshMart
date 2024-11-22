/**
 *  about controller
 */

import { factories } from '@strapi/strapi';

export default factories.createCoreController('api::about.about', ({strapi}) => ({
    async find(ctx) {
        const sanitizedQueryParams = await this.sanitizeQuery(ctx);
        const { results, pagination } = await strapi.service('api::about.about').find({
            populate: { gambar: true },
        });
        const sanitizedResults = await this.sanitizeOutput(results, ctx);
    
        return this.transformResponse(sanitizedResults, { pagination });
    }
}));