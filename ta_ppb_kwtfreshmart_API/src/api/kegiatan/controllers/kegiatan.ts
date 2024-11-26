/**
 * kegiatan controller
 */

import { factories } from '@strapi/strapi'

export default factories.createCoreController('api::kegiatan.kegiatan', ({strapi}) => ({
    async find(ctx) {
        const sanitizedQueryParams = await this.sanitizeQuery(ctx);
        const { results, pagination } = await strapi.service('api::kegiatan.kegiatan').find({
            populate: { gambar: true },
        });
        const sanitizedResults = await this.sanitizeOutput(results, ctx);
    
        return this.transformResponse(sanitizedResults, { pagination });
    }
}));
