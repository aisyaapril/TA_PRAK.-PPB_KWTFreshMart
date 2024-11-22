/**
 *  author controller
 */

import { factories } from '@strapi/strapi';

export default factories.createCoreController('api::author.author', ({strapi}) => ({
    async find(ctx) {
        const sanitizedQueryParams = await this.sanitizeQuery(ctx);
        const { results, pagination } = await strapi.service('api::author.author').find({
            populate: { gambar: true },
        });
        const sanitizedResults = await this.sanitizeOutput(results, ctx);
    
        return this.transformResponse(sanitizedResults, { pagination });
    },

    async findOne(ctx) {
       
            // Validasi parameter
            await this.validateQuery(ctx);
    
            const { id } = ctx.params;
    
            // Sanitasi query
            const sanitizedQueryParams = await this.sanitizeQuery(ctx);
    
            // Query database untuk mencari data berdasarkan slug
            const entity = await strapi.db.query('api::author.author').findOne({
                where: { slug: id }, // Gunakan `id` sebagai slug
                populate: { gambar: true }, // Populate field relasi jika diperlukan
            });
    
            // Jika data tidak ditemukan, kembalikan error 404
            if (!entity) {
                return ctx.notFound('Author not found');
            }
    
            // Sanitasi hasil untuk menghindari pengiriman data sensitif
            const sanitizedResults = await this.sanitizeOutput(entity, ctx);
    
            // Kembalikan hasil yang telah disanitasi
            return this.transformResponse(sanitizedResults);
    }
    
}));